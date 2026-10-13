-- Six read-only reports. Import university_management.sql first.
-- IDs keep people and events distinct even when names match.

-- 1. Enrollment roster, retaining enrollments with optional missing links.
SELECT e.enrollment_id, e.student_id,
       CONCAT(s.first_name, ' ', s.last_name) AS student,
       e.course_id, c.course_code, c.course_name, c.lecturer_id,
       CONCAT(l.first_name, ' ', l.last_name) AS lecturer,
       e.enrollment_date, e.grade
FROM enrollments AS e
LEFT JOIN students AS s ON s.student_id = e.student_id
LEFT JOIN courses AS c ON c.course_id = e.course_id
LEFT JOIN lecturers AS l ON l.lecturer_id = c.lecturer_id
ORDER BY e.enrollment_id;

-- 2. Course demand, including courses with no enrollments.
SELECT c.course_id, c.course_code, c.course_name,
       COUNT(e.enrollment_id) AS enrollment_count
FROM courses AS c
LEFT JOIN enrollments AS e ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_code, c.course_name
ORDER BY enrollment_count DESC, c.course_id;

-- 3. Student course load. Credits describe this fixture, not a calculated GPA.
SELECT s.student_id, CONCAT(s.first_name, ' ', s.last_name) AS student,
       COUNT(e.enrollment_id) AS enrollment_count,
       COALESCE(SUM(c.credit_units), 0) AS recorded_credit_units
FROM students AS s
LEFT JOIN enrollments AS e ON e.student_id = s.student_id
LEFT JOIN courses AS c ON c.course_id = e.course_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY enrollment_count DESC, s.student_id;

-- 4. Department coverage. Aggregate each child before joining to avoid fan-out.
SELECT d.department_id, d.department_name,
       COALESCE(s.student_count, 0) AS student_count,
       COALESCE(l.lecturer_count, 0) AS lecturer_count,
       COALESCE(c.course_count, 0) AS course_count
FROM department AS d
LEFT JOIN (
    SELECT department_id, COUNT(*) AS student_count
    FROM students GROUP BY department_id
) AS s ON s.department_id = d.department_id
LEFT JOIN (
    SELECT department_id, COUNT(*) AS lecturer_count
    FROM lecturers GROUP BY department_id
) AS l ON l.department_id = d.department_id
LEFT JOIN (
    SELECT department_id, COUNT(*) AS course_count
    FROM courses GROUP BY department_id
) AS c ON c.department_id = d.department_id
ORDER BY d.department_id;

-- 5. Distribution of recorded grades; the schema currently permits free text.
SELECT COALESCE(grade, 'Unassigned') AS recorded_grade,
       COUNT(*) AS enrollment_count
FROM enrollments
GROUP BY grade
ORDER BY recorded_grade;

-- 6. Students enrolled in more courses than the average across ALL students.
WITH student_counts AS (
    SELECT s.student_id, s.first_name, s.last_name,
           COUNT(e.enrollment_id) AS enrollment_count
    FROM students AS s
    LEFT JOIN enrollments AS e ON e.student_id = s.student_id
    GROUP BY s.student_id, s.first_name, s.last_name
)
SELECT student_id, CONCAT(first_name, ' ', last_name) AS student,
       enrollment_count
FROM student_counts
WHERE enrollment_count > (SELECT AVG(enrollment_count) FROM student_counts)
ORDER BY enrollment_count DESC, student_id;
