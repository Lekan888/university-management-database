# University Management System

A relational database built with MySQL for managing students, lecturers,
departments, courses, and student enrollments.

## Database Structure

The database contains 6 main tables:

- `departments`
- `students`
- `lecturers`
- `courses`
- `enrollments`
- `enrollment_audit`

## Features

- Student management
- Lecturer management
- Department management
- Course management
- Student enrollment management
- Enrollment auditing
- Prevention of duplicate course enrollment

## SQL Concepts Used

### Database Fundamentals
- CREATE DATABASE
- CREATE TABLE
- INSERT
- SELECT
- UPDATE
- DELETE

### Constraints
- PRIMARY KEY
- FOREIGN KEY
- AUTO_INCREMENT
- NOT NULL
- UNIQUE
- CHECK

### Queries
- WHERE
- ORDER BY
- JOINs
- Aggregate Functions
- GROUP BY
- HAVING
- Subqueries

### Advanced MySQL
- Views
- Stored Procedures
- Triggers
- Transactions
- COMMIT
- ROLLBACK

## Relationships

The database uses foreign keys to establish relationships between
students, departments, lecturers, courses, and enrollments.

Students and courses have a many-to-many relationship, which is
handled through the `enrollments` table.

## Views

Created a `student_academic_view` that combines:

- Student information
- Department
- Course
- Lecturer
- Grade
- Credit units
- Enrollment date

## Stored Procedures

Created stored procedures for tasks such as:

- Retrieving students
- Retrieving a student's courses
- Adding students
- Updating student grades

## Triggers

Created an enrollment audit system.

When an enrollment is created, updated, or deleted, the database can
automatically record the action in the `enrollment_audit` table.

## Technologies

- MySQL
- SQL
- MySQL Workbench

## Purpose

This project was created as a practical SQL learning project to
develop skills in relational database design, data manipulation,
queries, relationships, and advanced MySQL features.

## Author

Toriola Lekan
