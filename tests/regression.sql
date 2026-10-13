-- Behavioral checks in a disposable imported schema. Test changes are rolled back.
-- The temporary procedure is removed after success; it is not an application routine.
DROP PROCEDURE IF EXISTS test_portfolio_behavior;
DELIMITER $$
CREATE PROCEDURE test_portfolio_behavior()
BEGIN
    DECLARE rejected BOOLEAN DEFAULT FALSE;
    DECLARE new_student INT;
    DECLARE new_course INT;
    DECLARE new_enrollment INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF (SELECT COUNT(*) FROM student_acadmic_view) <> 24
       OR (SELECT COUNT(*) FROM enrollments) <> 24
       OR (SELECT SUM(c.credit_units) FROM enrollments e JOIN courses c ON c.course_id = e.course_id) <> 72
       OR (SELECT COUNT(*) FROM (
           SELECT student_id FROM enrollments GROUP BY student_id HAVING COUNT(*) = 3
       ) AS full_load) <> 6 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Academic report baseline differs';
    END IF;

    START TRANSACTION;

    -- A namesake student with no department or enrollments must appear as zero load.
    INSERT INTO students (first_name, last_name, email, date_of_birth)
    VALUES ('Daniel', 'Johnson', 'report-check@example.test', '2004-01-01');
    SET new_student = LAST_INSERT_ID();
    IF (SELECT COUNT(e.enrollment_id) FROM students s
        LEFT JOIN enrollments e ON e.student_id = s.student_id
        WHERE s.student_id = new_student) <> 0
       OR (SELECT COUNT(*) FROM students WHERE first_name = 'Daniel' AND last_name = 'Johnson') <> 2 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Zero-enrollment namesake not retained';
    END IF;

    INSERT INTO courses (course_code, course_name, credit_units)
    VALUES ('TEST0', 'Empty course regression', 3);
    SET new_course = LAST_INSERT_ID();
    IF (SELECT COUNT(e.enrollment_id) FROM courses c
        LEFT JOIN enrollments e ON e.course_id = c.course_id
        WHERE c.course_id = new_course) <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Empty course counted as an enrollment';
    END IF;

    -- The new LEFT JOIN roster retains this event; the legacy INNER JOIN view does not.
    INSERT INTO enrollments (enrollment_date) VALUES ('2026-10-01');
    SET new_enrollment = LAST_INSERT_ID();
    IF (SELECT COUNT(*) FROM enrollments e
        LEFT JOIN students s ON s.student_id = e.student_id
        LEFT JOIN courses c ON c.course_id = e.course_id
        LEFT JOIN lecturers l ON l.lecturer_id = c.lecturer_id
        WHERE e.enrollment_id = new_enrollment
          AND e.student_id IS NULL AND e.course_id IS NULL) <> 1
       OR (SELECT COUNT(*) FROM student_acadmic_view) <> 24 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Optional-link roster behavior differs';
    END IF;

    SET rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR 1062 SET rejected = TRUE;
        UPDATE enrollments SET student_id = 1, course_id = 1 WHERE enrollment_id = 4;
    END;
    IF NOT rejected THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate enrollment accepted';
    END IF;

    SET rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR 1452 SET rejected = TRUE;
        UPDATE enrollments SET course_id = -1 WHERE enrollment_id = 1;
    END;
    IF NOT rejected THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Unknown course reference accepted';
    END IF;

    SET rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR 3819 SET rejected = TRUE;
        UPDATE courses SET credit_units = 7 WHERE course_id = 1;
    END;
    IF NOT rejected THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid course credits accepted';
    END IF;

    SET rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR 3819 SET rejected = TRUE;
        UPDATE lecturers SET salary = -1 WHERE lecturer_id = 1;
    END;
    IF NOT rejected THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Negative salary accepted';
    END IF;

    UPDATE enrollments SET grade = 'C' WHERE enrollment_id = 1;
    IF (SELECT grade FROM enrollments WHERE enrollment_id = 1) <> 'C' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction update not applied';
    END IF;
    ROLLBACK;

    IF (SELECT COUNT(*) FROM students) <> 10
       OR (SELECT COUNT(*) FROM courses) <> 10
       OR (SELECT COUNT(*) FROM enrollments) <> 24
       OR (SELECT grade FROM enrollments WHERE enrollment_id = 1) <> 'A' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rollback did not restore academic fixture';
    END IF;
    SELECT 'University behavioral checks passed' AS result;
END$$
DELIMITER ;
CALL test_portfolio_behavior();
DROP PROCEDURE test_portfolio_behavior;
