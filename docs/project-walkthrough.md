# Presenting the university database

## Five-minute demonstration

1. Open the README's schema table. Explain the student → enrollment ← course relationship and why its composite UNIQUE constraint prevents duplicate non-null pairs.
2. Import `university_management.sql` into a disposable MySQL 8.0 schema and run `verify.sql`. Expect 27 PASS results.
3. Run reports 1 and 3 in `reports.sql`. Explain stable record IDs, why LEFT JOIN keeps optional relationships and why COUNT(enrollment_id) does not count an empty match.
4. Run report 4. Explain why students, lecturers and courses are aggregated separately before their department counts are joined.
5. Run `tests/regression.sql`, then rerun `verify.sql`. Explain duplicate/FK/CHECK rejection, the namesake and empty-course cases and rollback.
6. Show the GitHub Actions result and describe how the TSV gate catches a FAIL even when MySQL itself exits successfully.

## Interview prompts

- **What does the original academic view omit?** INNER JOINs omit enrollments missing related details. The separate roster uses LEFT JOINs; the original view name and behavior are preserved.
- **Do you calculate GPA?** No. Reports count enrollments and sum recorded credits; no grade-point mapping or semester model is defined.
- **Are audit events generated automatically?** No. Eight historical audit rows are seeded; the export has no application triggers or routines.
- **What would you add next?** Define semester and grade rules before changing the schema; recover and test any original audit/procedure definitions before claiming them.
- **Why can IDs have gaps after tests?** InnoDB rollback restores rows, but auto-increment allocations can advance.
