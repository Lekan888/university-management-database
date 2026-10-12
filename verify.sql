-- Run after importing university_management.sql into a fresh, selected schema.
-- Read-only: every result should be PASS for the shipped fixture.
-- Check result values; SQL execution alone does not turn FAIL into an error.

SELECT DATABASE() AS selected_database, VERSION() AS server_version;

SELECT check_name, expected_value, actual_value,
       CASE WHEN actual_value = expected_value THEN 'PASS' ELSE 'FAIL' END AS result
FROM (
    SELECT 'base_table_count' AS check_name, '6' AS expected_value,
           CAST(COUNT(*) AS CHAR) AS actual_value
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_TYPE = 'BASE TABLE'
    UNION ALL
    SELECT 'innodb_table_count', '6', CAST(COUNT(*) AS CHAR)
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_TYPE = 'BASE TABLE' AND ENGINE = 'InnoDB'
    UNION ALL
    SELECT 'academic_view_definition', '1', CAST(COUNT(*) AS CHAR)
    FROM information_schema.VIEWS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'student_acadmic_view'
    UNION ALL SELECT 'department_rows', '5', CAST(COUNT(*) AS CHAR) FROM department
    UNION ALL SELECT 'students_rows', '10', CAST(COUNT(*) AS CHAR) FROM students
    UNION ALL SELECT 'lecturers_rows', '5', CAST(COUNT(*) AS CHAR) FROM lecturers
    UNION ALL SELECT 'courses_rows', '10', CAST(COUNT(*) AS CHAR) FROM courses
    UNION ALL SELECT 'enrollments_rows', '24', CAST(COUNT(*) AS CHAR) FROM enrollments
    UNION ALL SELECT 'enrollment_audit_rows', '8', CAST(COUNT(*) AS CHAR) FROM enrollment_audit
    UNION ALL
    SELECT 'foreign_key_count', '6', CAST(COUNT(*) AS CHAR)
    FROM information_schema.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_TYPE = 'FOREIGN KEY'
    UNION ALL
    SELECT 'enrollment_unique_pair_definition', '1', CAST(COUNT(*) AS CHAR)
    FROM (
        SELECT INDEX_NAME
        FROM information_schema.STATISTICS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'enrollments' AND NON_UNIQUE = 0
        GROUP BY INDEX_NAME
        HAVING GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX SEPARATOR ',') = 'student_id,course_id'
    ) AS pair_indexes
    UNION ALL
    SELECT 'duplicate_enrollment_pairs', '0', CAST(COUNT(*) AS CHAR)
    FROM (
        SELECT student_id, course_id
        FROM enrollments
        GROUP BY student_id, course_id
        HAVING COUNT(*) > 1
    ) AS duplicate_pairs
    UNION ALL
    SELECT 'fixture_null_enrollment_links', '0', CAST(COUNT(*) AS CHAR)
    FROM enrollments WHERE student_id IS NULL OR course_id IS NULL
    UNION ALL
    SELECT 'orphan_students_department', '0', CAST(COUNT(*) AS CHAR)
    FROM students x LEFT JOIN department p ON x.department_id = p.department_id
    WHERE x.department_id IS NOT NULL AND p.department_id IS NULL
    UNION ALL
    SELECT 'orphan_lecturers_department', '0', CAST(COUNT(*) AS CHAR)
    FROM lecturers x LEFT JOIN department p ON x.department_id = p.department_id
    WHERE x.department_id IS NOT NULL AND p.department_id IS NULL
    UNION ALL
    SELECT 'orphan_courses_department', '0', CAST(COUNT(*) AS CHAR)
    FROM courses x LEFT JOIN department p ON x.department_id = p.department_id
    WHERE x.department_id IS NOT NULL AND p.department_id IS NULL
    UNION ALL
    SELECT 'orphan_courses_lecturer', '0', CAST(COUNT(*) AS CHAR)
    FROM courses x LEFT JOIN lecturers p ON x.lecturer_id = p.lecturer_id
    WHERE x.lecturer_id IS NOT NULL AND p.lecturer_id IS NULL
    UNION ALL
    SELECT 'orphan_enrollments_student', '0', CAST(COUNT(*) AS CHAR)
    FROM enrollments x LEFT JOIN students p ON x.student_id = p.student_id
    WHERE x.student_id IS NOT NULL AND p.student_id IS NULL
    UNION ALL
    SELECT 'orphan_enrollments_course', '0', CAST(COUNT(*) AS CHAR)
    FROM enrollments x LEFT JOIN courses p ON x.course_id = p.course_id
    WHERE x.course_id IS NOT NULL AND p.course_id IS NULL
    UNION ALL
    SELECT 'academic_view_rows', '24', CAST(COUNT(*) AS CHAR) FROM student_acadmic_view
    UNION ALL
    SELECT 'academic_view_sample', 'CSC101:A:3|CSC201:B:3|CSC301:A:3',
           GROUP_CONCAT(CONCAT_WS(':', course_code, grade, credit_units)
                        ORDER BY course_code SEPARATOR '|')
    FROM student_acadmic_view WHERE first_name = 'Daniel' AND last_name = 'Johnson'
    UNION ALL
    SELECT 'shipped_routine_count', '0', CAST(COUNT(*) AS CHAR)
    FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = DATABASE()
    UNION ALL
    SELECT 'shipped_trigger_count', '0', CAST(COUNT(*) AS CHAR)
    FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA = DATABASE()
    UNION ALL
    SELECT 'check_constraint_count', '2', CAST(COUNT(*) AS CHAR)
    FROM information_schema.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_TYPE = 'CHECK'
    UNION ALL
    SELECT 'fixture_invalid_credits', '0', CAST(COUNT(*) AS CHAR)
    FROM courses WHERE credit_units IS NOT NULL AND credit_units NOT BETWEEN 1 AND 6
    UNION ALL
    SELECT 'fixture_invalid_salaries', '0', CAST(COUNT(*) AS CHAR)
    FROM lecturers WHERE salary IS NOT NULL AND salary <= 0
    UNION ALL
    SELECT 'foreign_key_checks_enabled', '1', CAST(@@SESSION.foreign_key_checks AS CHAR)
) AS checks
ORDER BY check_name;
