# University Management Database

A MySQL learning project modeling students, departments, lecturers, courses, and enrollments. The repository ships six InnoDB tables, six foreign-key relationships, 62 seed records, and a five-table academic view.

## Files and run order

| File | Purpose | Order |
| --- | --- | --- |
| `university_management.sql` | Table definitions, constraints, seed data, and the academic view | 1: import into a new database |
| `verify.sql` | Read-only checks with actual and expected values | 2: run after a successful import |
| `README.md` | Setup instructions, expected results, constraint checks, and project limitations | Read before importing |

The dump already handles its internal loading order. Do not run its table sections individually.

## Setup

Use a running MySQL 8.0 server and the `mysql` command-line client, or MySQL Workbench connected to that server. The original dump was exported from MySQL **8.0.46** and uses `utf8mb4_0900_ai_ci`. MySQL 5.7 and MariaDB are not supported targets for this dump.

Use an account allowed to create the target schema and import its objects. Importing uses CREATE/DROP/ALTER TABLE, INSERT, LOCK TABLES, and CREATE VIEW; verification needs SELECT and visibility of the imported schema's metadata. The view uses `SQL SECURITY INVOKER`, so its caller needs SELECT access to the underlying tables. It has no hardcoded root definer.

From a terminal:

```sh
git clone https://github.com/Lekan888/university-management-database.git
cd university-management-database
mysql -u root -p
```

Substitute your configured local import account for `root`. At the `mysql>` prompt:

```sql
CREATE DATABASE university_management_demo
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE university_management_demo;
SOURCE university_management.sql;
SOURCE verify.sql;
```

Create a **new disposable database**. If creation fails because the name already exists, stop and choose another name before importing. The dump contains DROP TABLE statements: rerunning it in an existing target replaces its six tables and their data. It contains no CREATE DATABASE or USE statement, so the selected database determines where it is imported. Review the import output for errors before running verification.

SOURCE is a command for the `mysql` client, including when it is launched from Windows PowerShell. In Workbench, run CREATE DATABASE and USE first; then open and execute `university_management.sql`, followed by `verify.sql`, using the same selected schema. Do not paste SOURCE commands into a Workbench SQL editor.

## Schema and implemented features

| Table | Role | Seed rows |
| --- | --- | ---: |
| `department` | Department names | 5 |
| `students` | Student details and department reference | 10 |
| `lecturers` | Lecturer details, salary, and department reference | 5 |
| `courses` | Course code, credits, department, and lecturer references | 10 |
| `enrollments` | Student-course links, enrollment date, and grade | 24 |
| `enrollment_audit` | Previously recorded enrollment/grade events | 8 |
| **Total** | Base-table records; the view adds no stored records | **62** |

`students` and `lecturers` reference `department`. `courses` references both `department` and `lecturers`. `enrollments` references `students` and `courses`, forming the student-course many-to-many relationship. `enrollment_audit` stores identifiers but has no foreign-key constraints.

Implemented constraints include primary keys, AUTO_INCREMENT, unique department names, course codes and student/lecturer emails, a composite UNIQUE key on `(student_id, course_id)`, CHECK constraints on course credits (1–6) and lecturer salary (>0), and selected NOT NULL columns. The enrollment uniqueness constraint prevents duplicate **non-null** student-course pairs; both reference columns currently allow NULL.

The view is named **`student_acadmic_view`** in the original database; this spelling is retained for compatibility. It joins students, department, enrollments, courses, and lecturers to display student names, department, course, lecturer, credits, grade, and enrollment date. It does not expose student or enrollment IDs.

## Verification and expected results

`verify.sql` reports the selected schema and server version, then returns **27 checks** with `check_name`, `expected_value`, `actual_value`, and `result`. Every check should be PASS on a clean import. A FAIL means the observed value differs from the documented snapshot. This file does not raise SQL errors or change records; automated runners should treat any FAIL as a failed check.

The checks cover object/engine counts, all table row counts above, six foreign keys and their orphan counts, enrollment uniqueness, nullable enrollment links in this fixture, both CHECK definitions and the supplied values, the view, restored foreign-key checking, and the absence of shipped procedures/functions/triggers.

Expected baseline: six base tables, one view, six foreign keys, two CHECK constraints, zero duplicate enrollment pairs, zero orphan references, and 24 academic-view rows. The fixture contains no NULL enrollment links, although the schema permits them. Routine and trigger counts are both **zero** for this export.

This query provides a small ordered academic report:

```sql
SELECT course_code, grade, credit_units
FROM student_acadmic_view
WHERE first_name = 'Daniel' AND last_name = 'Johnson'
ORDER BY course_code;
```

| course_code | grade | credit_units |
| --- | --- | ---: |
| CSC101 | A | 3 |
| CSC201 | B | 3 |
| CSC301 | A | 3 |

### Manual constraint and rollback checks

Use the disposable imported database. Execute statements individually, completing ROLLBACK even after an expected error. Do not include expected-error statements in the normal verification batch.

For each of these attempts, first run START TRANSACTION, execute the UPDATE, then run ROLLBACK:

| UPDATE attempt | Expected MySQL 8.0 behavior |
| --- | --- |
| `UPDATE enrollments SET student_id = 1, course_id = 1 WHERE enrollment_id = 4;` | Duplicate-key error 1062 |
| `UPDATE enrollments SET course_id = 999999 WHERE enrollment_id = 1;` | Foreign-key error 1452 with foreign-key checks enabled |
| `UPDATE courses SET credit_units = 7 WHERE course_id = 1;` | CHECK-constraint error 3819 |

A transaction demonstration for the existing InnoDB tables:

```sql
START TRANSACTION;
UPDATE enrollments SET grade = 'C' WHERE enrollment_id = 1;
SELECT grade FROM enrollments WHERE enrollment_id = 1; -- C
ROLLBACK;
SELECT grade FROM enrollments WHERE enrollment_id = 1; -- A again
```

These examples demonstrate engine transaction behavior; they do not implement a new application workflow. Run `verify.sql` again afterward to confirm the fixture remains intact.

## Portfolio description

Designed a six-table MySQL university database with six foreign keys and 62 seeded records. Modeled student-course enrollment with a composite uniqueness constraint and built a five-table academic view. Verified the documented import on MySQL 8.0.46 with a non-root account and 27 read-only checks; demonstrated duplicate rejection, foreign-key enforcement, CHECK constraints, and transaction rollback.

## Current limitations and future work

The committed dump has **no stored procedure/function or trigger definitions**. Its eight audit records are historical seed data; new enrollment actions are not automatically logged by this export. Earlier documentation described procedures and audit triggers, but the repository cannot recreate them. Recover actual definitions from the original working database before claiming these features are implemented here. `mysqldump --routines --triggers` can export them if they exist and the account has the required privileges.

Enrollment references, credit units, salary, emails, and other relationships allow NULL where the schema permits it. There is no grade-domain CHECK constraint or semester model; the composite enrollment key also prevents recording the same student-course pair in a later term. Seed spellings such as `Business Adminidtration` are retained from the original data.

Possible later improvements: recover and test the original procedures/audit triggers, strengthen required fields and grade validation, add a correctly named view with stable IDs, model semesters, and add more reporting examples. These are future changes, not current features.

## Validation record

Validated on **12 October 2026** using MySQL **8.0.46-0ubuntu0.24.04.3** on Linux:

- Fresh import through the documented SOURCE flow using a non-root account with privileges scoped to the target schema: passed.
- All 27 verification checks: PASS.
- View creation and query access with the importing account as definer and SQL SECURITY INVOKER: passed.
- Duplicate enrollment rejected with error 1062; invalid course reference rejected with error 1452; invalid credit units and salary rejected with error 3819.
- Transaction rollback restored enrollment 1's grade from C to A.
- A deliberately changed grade produced FAIL for the academic-view sample; rollback restored all 27 PASS results.
- Reimport into the disposable schema restored the documented snapshot and all 27 PASS results.

Other server versions and operating systems have not been tested. The SQL client flow is documented for Windows as well as Linux, but the validation above was performed on Linux.

## Author

Toriola Lekan
