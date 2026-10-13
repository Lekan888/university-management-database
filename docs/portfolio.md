# University Management Database — Portfolio Copy

**Lekan Toriola | MySQL, SQL, Relational Database Design**

Repository: [Lekan888/university-management-database](https://github.com/Lekan888/university-management-database)

## Resume bullets

**University Management Database | MySQL, SQL, GitHub Actions**

- Designed a six-table MySQL database with six foreign keys, 62 sample records and a five-table academic view for students, courses and enrollments.
- Enforced unique student-course pairs and added six SQL reports using joins, aggregation, CTEs and subqueries to analyze course demand, student loads and department coverage.
- Combined 27 read-only verification checks with behavioral tests for duplicate enrollment, invalid references, CHECK constraints, optional relationships and transaction rollback.
- Added automated MySQL verification in GitHub Actions, failure detection for changed fixtures, reproducible setup documentation and an interview walkthrough.

## LinkedIn project description

Built a MySQL university database modelling students, departments, lecturers, courses and enrollments across six tables, six foreign-key relationships and 62 sample records. A composite UNIQUE constraint prevents duplicate non-null student-course registrations. Added six SQL reports for enrollment rosters, course demand, student loads, department coverage, grade distribution and above-average enrollment counts. The project includes a five-table academic view, 27 read-only verification checks, automated MySQL verification, behavioral tests, reproducible setup instructions and interview notes.

**Skills:** SQL, MySQL, relational database design, reporting, data integrity, regression testing, GitHub Actions, technical documentation.

**Project link:** https://github.com/Lekan888/university-management-database

## GitHub repository description

MySQL university database: 6 tables, 62 sample records, an academic view and 6 SQL reports, with integrity checks, rollback tests, GitHub Actions and reproducible setup.

## Short portfolio case study

**Goal.** Demonstrate relational modelling, enrollment integrity and SQL analysis in a university-data learning project.

**Implementation.** Built six InnoDB tables with six foreign keys, a composite enrollment uniqueness constraint and two CHECK constraints. The fixture contains 62 sample records and a five-table academic view. Six reports use joins, aggregation, CTEs and subqueries to examine enrollments, course demand, student course loads, department coverage and recorded grades.

**Design decision.** The reporting roster exposes record IDs and uses LEFT JOINs to retain optional relationships. Department coverage aggregates each child table before joining, avoiding multiplied counts. Reports group students by IDs so people with matching names remain distinct. The existing academic view and its legacy spelling remain compatible.

**Verification.** A GitHub Actions workflow imports the database into MySQL 8.0, checks all 27 verification results, executes the reports and runs constraint/rollback tests. The verification gate rejects FAIL results and malformed output; an intentionally changed grade tests failure detection. Eight Python unit tests exercise the gate.

**Current scope.** No application interface, GPA calculation or semester model is implemented. Enrollment references remain nullable. The eight audit records are historical seed data; no application routines or audit triggers are shipped. A temporary procedure exists only during behavioral tests and is dropped afterward.

**Possible future improvements.** Define semester and grade rules, strengthen required fields, and recover and test the original application procedures/audit triggers if their definitions still exist.

## Evidence

| Claim | Implemented evidence |
| --- | --- |
| Schema, relationships, 62 sample rows and the academic view | [Source](../university_management.sql) |
| Six runnable SQL reports | [Source](../reports.sql) |
| 27 baseline verification checks | [Source](../verify.sql) |
| Constraint, optional-link and rollback behavior | [Source](../tests/regression.sql) |
| Verification gate and eight unit tests | [Source](../scripts/check_verification.py) |
| Automated MySQL import, report execution and failure detection | [Source](../.github/workflows/mysql.yml) |
| Setup, prior validation record and current limitations | [Source](../README.md) |
| Demonstration and interview notes | [Source](project-walkthrough.md) |

The sample counts describe the bundled fixture, not real operational scale. Future improvements above are suggestions, not completed features.
