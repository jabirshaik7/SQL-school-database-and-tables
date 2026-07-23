CREATE DATABASE school_db;
USE school_db;

-- Student Table
CREATE TABLE student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    student_age INT,
    student_branch VARCHAR(30)
);

-- Teacher Table
CREATE TABLE teacher (
    teacher_id INT PRIMARY KEY,
    teacher_name VARCHAR(50) NOT NULL,
    subject VARCHAR(30),
    salary DECIMAL(10,2)
);

Drop table teacher;

ALTER TABLE student ADD student_phno BIGINT;   -- Add new column
RENAME TABLE teacher TO faculty;               -- Rename table
TRUNCATE TABLE student;                        -- Remove all rows quickly
DROP TABLE faculty;                            -- Delete table permanently

-- Insert
INSERT INTO student VALUES (1, 'Jabir', 22, 'CSE', 9876543210);
INSERT INTO student VALUES (2, 'Ahamed', 23, 'ECE', 9876501234);
select * from student;

INSERT INTO teacher VALUES (101, 'Ramesh', 'Maths', 45000.00);
INSERT INTO teacher VALUES (102, 'Suresh', 'Physics', 50000.00);
select * from teacher;
-- Update
UPDATE student SET student_age = 24 WHERE student_id = 2;

-- Delete
DELETE FROM teacher WHERE teacher_id = 101;

-- Merge (MySQL equivalent: INSERT ... ON DUPLICATE KEY UPDATE)
INSERT INTO student (student_id, student_name, student_age, student_branch, student_phno)
VALUES (3, 'Rahul', 21, 'IT', 9876509876)
ON DUPLICATE KEY UPDATE student_age = VALUES(student_age);


GRANT SELECT, INSERT ON student TO 'user1'@'localhost';
REVOKE INSERT ON student FROM 'user1'@'localhost';


START TRANSACTION;

INSERT INTO student VALUES (4, 'Priya', 22, 'EEE', 9876512345);

SAVEPOINT sp1;

UPDATE student SET student_branch = 'MECH' WHERE student_id = 4;

ROLLBACK TO sp1;   -- Undo branch change, but keep insert

COMMIT;            -- Finalize transaction

--- With this, you’ve used all SQL command types:

-- DDL → Create, Alter, Drop, Truncate, Rename
-- DML → Insert, Update, Delete, Merge
-- DCL → Grant, Revoke
-- TCL → Commit, Rollback, Savepoint
-- DQL → Select

                    -- SQL ADVANCE METHOD USD IN MYSQL --

-- Create table with constraints

-- Advanced DDL (Data Definition Language)
CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(50) NOT NULL,
    student_age INT CHECK (student_age >= 18),
    student_branch VARCHAR(30),
    student_phno BIGINT UNIQUE
);

CREATE TABLE teacher (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_name VARCHAR(50) NOT NULL,
    subject VARCHAR(30),
    salary DECIMAL(10,2) DEFAULT 30000,
    CONSTRAINT salary_check CHECK (salary > 0)
);

-- Advanced features used:

AUTO_INCREMENT for automatic IDs

CHECK constraints for validation

DEFAULT values

FOREIGN KEY for relationships

Column renaming

-- Add foreign key relationship
ALTER TABLE student 
ADD advisor_id INT,
ADD CONSTRAINT fk_teacher FOREIGN KEY (advisor_id) REFERENCES teacher(teacher_id);

-- Rename column
ALTER TABLE teacher RENAME COLUMN subject TO specialization;

-- Advanced features used:

AUTO_INCREMENT for automatic IDs

CHECK constraints for validation

DEFAULT values

FOREIGN KEY for relationships

Column renaming

-- Advanced DML (Data Manipulation Language) --

-- Insert multiple rows at once
INSERT INTO student (student_name, student_age, student_branch, student_phno)
VALUES 
('Jabir', 22, 'CSE', 9876543210),
('Ahamed', 23, 'ECE', 9876501234),
('Priya', 21, 'IT', 9876512345);

-- Update with JOIN (assign advisor)
UPDATE student s
JOIN teacher t ON t.specialization = 'Maths'
SET s.advisor_id = t.teacher_id
WHERE s.student_branch = 'CSE';

-- Delete with condition
DELETE FROM student WHERE student_age < 20;

-- MERGE equivalent (UPSERT)
INSERT INTO teacher (teacher_id, teacher_name, specialization, salary)
VALUES (1, 'Ramesh', 'Maths', 45000)
ON DUPLICATE KEY UPDATE salary = VALUES(salary);

Advanced features used:

Multi-row insert

UPDATE ... JOIN

Conditional delete

UPSERT pattern

-- Advanced DCL (Data Control Language) --

-- Create a role for teachers
CREATE ROLE teacher_role;

-- Grant role privileges
GRANT SELECT, UPDATE ON student TO teacher_role;

-- Assign role to a user
GRANT teacher_role TO 'teacher_user'@'localhost';

-- Revoke privileges
REVOKE UPDATE ON student FROM teacher_role;
 
-- Advanced features used:

Roles for grouping privileges

Assigning roles to users

-- Advanced TCL (Transaction Control Language)
START TRANSACTION;

-- Insert new student
INSERT INTO student (student_name, student_age, student_branch, student_phno)
VALUES ('Rahul', 22, 'EEE', 9876509876);

SAVEPOINT sp_insert;

-- Update salary of teacher
UPDATE teacher SET salary = salary + 5000 WHERE teacher_name = 'Suresh';

-- Rollback only salary update
ROLLBACK TO sp_insert;

COMMIT;

-- Advanced features used:

Savepoints for partial rollback

Transaction grouping

-- Advanced DQL (Data Query Language) --

-- Simple select
SELECT * FROM student;

-- Aggregate functions
SELECT student_branch, COUNT(*) AS total_students, AVG(student_age) AS avg_age
FROM student
GROUP BY student_branch
HAVING COUNT(*) > 1;

-- Join query
SELECT s.student_name, t.teacher_name, t.specialization
FROM student s
JOIN teacher t ON s.advisor_id = t.teacher_id;

-- Subquery
SELECT student_name 
FROM student 
WHERE student_age > (SELECT AVG(student_age) FROM student);

-- Window function
SELECT student_name, student_age,
       RANK() OVER (ORDER BY student_age DESC) AS age_rank
FROM student;

-- Advanced features used:

GROUP BY + HAVING

Joins

Subqueries

Window functions (RANK())

-- SUMMARY --

DDL → Constraints, foreign keys, renaming

DML → Multi-row insert, UPSERT, JOIN updates

DCL → Roles, privilege management

TCL → Savepoints, partial rollbacks

DQL → Aggregates, joins, subqueries, window functions


-- Aggregate Functions in student Table --

-- Count students per branch
SELECT student_branch, COUNT(*) AS total_students
FROM student
GROUP BY student_branch;

-- Average age of students per branch
SELECT student_branch, AVG(student_age) AS avg_age
FROM student
GROUP BY student_branch;

-- Maximum and minimum age
SELECT MAX(student_age) AS oldest, MIN(student_age) AS youngest
FROM student;

-- Total students above average age
SELECT COUNT(*) AS above_avg_students
FROM student
WHERE student_age > (SELECT AVG(student_age) FROM student);

-- Using HAVING to filter groups
SELECT student_branch, COUNT(*) AS total_students
FROM student
GROUP BY student_branch
HAVING COUNT(*) > 2;

-- Aggregate Functions in teacher Table --

-- Total salary expenditure
SELECT SUM(salary) AS total_salary
FROM teacher;

-- Average salary per specialization
SELECT specialization, AVG(salary) AS avg_salary
FROM teacher
GROUP BY specialization;

-- Highest paid teacher
SELECT teacher_name, MAX(salary) AS highest_salary
FROM teacher;

-- Lowest paid teacher per subject
SELECT specialization, MIN(salary) AS lowest_salary
FROM teacher
GROUP BY specialization;

-- Count teachers per subject
SELECT specialization, COUNT(*) AS total_teachers
FROM teacher
GROUP BY specialization;

-- 1. Advanced Aggregate Queries (Joins + Window Functions) --

SELECT s.student_name, t.teacher_name, t.salary,
       RANK() OVER (ORDER BY t.salary DESC) AS salary_rank
FROM student s
JOIN teacher t ON s.advisor_id = t.teacher_id;
-- 2. Branch-wise student distribution with percentage --