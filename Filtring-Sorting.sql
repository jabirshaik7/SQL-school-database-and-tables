create database Techcompany;
use Techcompany;
drop table employees;

CREATE TABLE employees(
EmpID INT PRIMARY KEY,
Name VARCHAR(50),
Department VARCHAR(50),
Salary DECIMAL(10, 2),
Age INT,
HireData DATE 
);

INSERT INTO employees (EmpID, Name, Department, Salary, Age, HireDate)
VALUES
(101, 'jabir', 'IT', 50000, 23, '2026-12-10'),
(102, 'vamshi', 'NIT', 56700, 33, '2026-11-16'),
(103, 'raja', 'MIIT', 80000, 43, '2026-06-15'),
(104, 'malik', 'IIT', 67000, 24, '2026-10-19'),
(105, 'jigar', 'INT', 45000, 26, '2026-09-12'),
(106, 'vahir', 'IRT', 55000, 28, '2026-04-10');

ALTER TABLE employees
CHANGE HireData HireDate DATE;

select * from employees;
DESCRIBE employees;

SELECT * 
FROM Employees
WHERE Department = 'IT';

SELECT Name 
FROM Employees
WHERE Name LIKE 'A%';

SELECT Name, Department
FROM Employees
WHERE Department IN ('HR', 'Finance');

SELECT Name, Salary
FROM Employees
WHERE Salary BETWEEN 50000 AND 80000;

SELECT Name, Age, Department
FROM Employees
WHERE Department = 'IT' AND Age > 30;

SELECT Name, Salary
FROM Employees
ORDER BY Salary DESC;


SELECT Name, Department, Salary
FROM Employees
ORDER BY Department ASC, Salary DESC;


SELECT Name, Salary
FROM Employees
ORDER BY Salary DESC
LIMIT 3;

SELECT DISTINCT Department
FROM Employees;


SELECT Name, Department, Salary
FROM Employees
WHERE Department IN ('IT', 'Finance')
  AND Salary BETWEEN 60000 AND 90000
ORDER BY Salary DESC
LIMIT 5;








