CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50));


	-- Employees Table
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    hire_date DATE,
    salary NUMERIC(10,2),
    dept_id INT REFERENCES departments(dept_id)
);


-- Projects Table
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget NUMERIC(12,2)
);

-- Employee_Project (Many-to-Many mapping)
CREATE TABLE employee_project (
    emp_id INT REFERENCES employees(emp_id),
    project_id INT REFERENCES projects(project_id),
    role VARCHAR(50),
    PRIMARY KEY (emp_id, project_id)
);



-- Insert Departments
INSERT INTO departments (dept_name, location) VALUES
('HR', 'New York'),
('Finance', 'Chicago'),
('IT', 'San Francisco'),
('Marketing', 'Boston'),
('Operations', 'Dallas');

-- Insert Employees
INSERT INTO employees (first_name, last_name, email, hire_date, salary, dept_id) VALUES
('John', 'Doe', 'john.doe@company.com', '2019-03-15', 60000, 1),
('Jane', 'Smith', 'jane.smith@company.com', '2020-07-01', 75000, 2),
('Robert', 'Brown', 'robert.brown@company.com', '2018-01-20', 90000, 3),
('Emily', 'Davis', 'emily.davis@company.com', '2021-06-12', 50000, 1),
('Michael', 'Wilson', 'michael.wilson@company.com', '2017-09-17', 120000, 3),
('Sarah', 'Johnson', 'sarah.johnson@company.com', '2019-11-05', 65000, 4),
('David', 'Lee', 'david.lee@company.com', '2022-02-10', 48000, 5),
('Anna', 'Taylor', 'anna.taylor@company.com', '2021-12-01', 54000, 4),
('James', 'Miller', 'james.miller@company.com', '2016-05-23', 130000, 2),
('Olivia', 'Moore', 'olivia.moore@company.com', '2020-09-15', 70000, 3),
('Daniel', 'Martin', 'daniel.martin@company.com', '2018-04-19', 88000, 5),
('Sophia', 'Garcia', 'sophia.garcia@company.com', '2021-01-25', 52000, 1),
('Chris', 'Rodriguez', 'chris.rodriguez@company.com', '2017-08-11', 115000, 2),
('Isabella', 'Hernandez', 'isabella.hernandez@company.com', '2022-06-18', 47000, 4),
('Matthew', 'Lopez', 'matthew.lopez@company.com', '2019-02-08', 78000, 3);

-- Insert Projects
INSERT INTO projects (project_name, start_date, end_date, budget) VALUES
('HR Management System', '2021-01-01', '2021-12-31', 200000),
('Financial Dashboard', '2020-05-01', '2021-04-30', 350000),
('Cloud Migration', '2019-07-01', '2020-12-31', 500000),
('Marketing Campaign 2021', '2021-03-01', '2021-09-30', 150000),
('Supply Chain Optimization', '2020-01-01', '2021-06-30', 400000);

-- Assign Employees to Projects
INSERT INTO employee_project (emp_id, project_id, role) VALUES
(1, 1, 'Analyst'),
(2, 2, 'Manager'),
(3, 3, 'Lead Engineer'),
(4, 1, 'HR Assistant'),
(5, 3, 'Architect'),
(6, 4, 'Marketing Specialist'),
(7, 5, 'Coordinator'),
(8, 4, 'Designer'),
(9, 2, 'Finance Head'),
(10, 3, 'Cloud Engineer'),
(11, 5, 'Operations Manager'),
(12, 1, 'Recruiter'),
(13, 2, 'Analyst'),
(14, 4, 'Intern'),
(15, 3, 'Developer');


SELECT * FROM employee_project

SELECT * FROM projects

SELECT * FROM employees

SELECT * FROM departments



--1)Find average salary per department

SELECT
	DEPT_ID,
	ROUND(AVG(SALARY), 2) AS AVERAGE_SALARY
FROM
	EMPLOYEES
GROUP BY
	DEPT_ID;

	
--2)Departments with average salary > 70000
SELECT
	DEPT_ID,
	ROUND(AVG(SALARY), 2) AS AVERAGE_SALARY
FROM
	EMPLOYEES
GROUP BY
	DEPT_ID
HAVING
	AVG(SALARY) > 70000;

	
--3)Count employees in each department
SELECT
	DEPT_ID,
	COUNT(*) AS EMP_COUNT
FROM
	EMPLOYEES
GROUP BY
	DEPT_ID;


--4) Find max salary in IT department 
SELECT
	MAX(SALARY)
FROM
	EMPLOYEES
WHERE
	DEPT_ID = 3;
	

--5) Get employees whose name starts with 'J'
SELECT
	*
FROM
	EMPLOYEES
WHERE
	FIRST_NAME LIKE 'J%';
	

--6) Get employees whose email contains 'company' 
SELECT
	*
FROM
	EMPLOYEES
WHERE
	EMAIL LIKE '%company%';


--7)Get employees not in HR department 
 SELECT
	*
FROM
	EMPLOYEES
WHERE
	DEPT_ID <> 3;


--8) Get all distinct roles in projects
SELECT DISTINCT
	ROLE
FROM
	EMPLOYEE_PROJECT;


--9) Get employees and their department names (INNER JOIN)
SELECT
	E.EMP_ID,
	E.FIRST_NAME,
	E.LAST_NAME,
	E.DEPT_ID,
	D.DEPT_NAME
FROM
	EMPLOYEES AS E
	INNER JOIN DEPARTMENTS AS D ON E.DEPT_ID = D.DEPT_ID;


--10)Show all departments and employees (LEFT JOIN) 
SELECT
	D.DEPT_ID,
	D.DEPT_NAME,
	E.EMP_ID,
	E.FIRST_NAME,
	E.LAST_NAME
FROM
	DEPARTMENTS AS D
	LEFT JOIN EMPLOYEES AS E ON D.DEPT_ID = E.DEPT_ID
ORDER BY
	D.DEPT_ID;

--11)Find employees without projects
SELECT
	*
FROM
	EMPLOYEES
WHERE
	EMP_ID NOT IN (
		SELECT
			EMP_ID
		FROM
			EMPLOYEE_PROJECT
	);


--12)Find total project budget assigned per employee
SELECT
	E.FIRST_NAME,
	E.LAST_NAME,
	SUM(P.BUDGET) AS TOTAL_BUDGET
FROM
	EMPLOYEES AS E
	JOIN EMPLOYEE_PROJECT AS EP ON E.EMP_ID = EP.EMP_ID
	JOIN PROJECTS AS P ON EP.PROJECT_ID = P.PROJECT_ID
GROUP BY
	E.EMP_ID;


--13) Find department with maximum employees
SELECT
	DEPT_ID,
	COUNT(*) AS EMP_COUNT
FROM
	EMPLOYEES
GROUP BY
	DEPT_ID
ORDER BY
	EMP_COUNT DESC
LIMIT
	1;


--14)Get employees with salary more than department average
SELECT
	EMP_ID,
	SALARY,
	(
		SELECT
			AVG(SALARY)
		FROM
			EMPLOYEES
		WHERE
			DEPT_ID = DEPT_ID
	) AS AVG_DEPT_SALARY
FROM
	EMPLOYEES;


--15)Find employees in same department as 'Jane Smith'
SELECT
	FIRST_NAME,
	LAST_NAME
FROM
	EMPLOYEES
WHERE
	DEPT_ID = (
		SELECT
			DEPT_ID
		FROM
			EMPLOYEES
		WHERE
			FIRST_NAME = 'Jane'
			AND LAST_NAME = 'Smith'
	)
	AND FIRST_NAME != 'Jane'
	AND LAST_NAME != 'Smith';
	

--16)Employees with salary rank
SELECT
	EMP_ID,
	FIRST_NAME,
	LAST_NAME,
	SALARY,
	RANK() OVER (
		ORDER BY
			SALARY DESC
	) AS SALARY_RANK
FROM
	EMPLOYEES;


--17) Show number of employees hired each year
SELECT
	EXTRACT(
		YEAR
		FROM
			HIRE_DATE
	)::INT AS HIRE_YEAR,
	COUNT(*) AS HIRED_COUNT
FROM
	EMPLOYEES
GROUP BY
	HIRE_YEAR
ORDER BY
	HIRE_YEAR;
	

--18)Get all employees and their project roles (even if no project)
SELECT
	E.EMP_ID,
	E.FIRST_NAME,
	E.LAST_NAME,
	EP.ROLE
FROM
	EMPLOYEES AS E
	LEFT JOIN EMPLOYEE_PROJECT AS EP ON E.EMP_ID = EP.EMP_ID;


--19) Get average salary of employees in San Francisco
SELECT
	D.DEPT_NAME,
	D.LOCATION,
	ROUND(AVG(E.SALARY), 2) AS AVERAGE_SALARY
FROM
	EMPLOYEES AS E
	JOIN DEPARTMENTS AS D ON E.DEPT_ID = D.DEPT_ID
WHERE
	D.LOCATION = 'San Francisco'
GROUP BY
	D.DEPT_NAME,
	D.LOCATION;


--20)Get employee names concatenated 
SELECT
	EMP_ID,
	FIRST_NAME || ' ' || LAST_NAME AS FULL_NAME
FROM
	EMPLOYEES;


--21)Employees not assigned to any department
SELECT
	E.EMP_ID,
	E.FIRST_NAME,
	E.LAST_NAME,
	D.DEPT_NAME
FROM
	EMPLOYEES AS E
	LEFT JOIN DEPARTMENTS AS D ON E.DEPT_ID = D.DEPT_ID
WHERE
	E.DEPT_ID IS NULL;
	

--22)Get project with highest budget 
SELECT
	PROJECT_ID,
	PROJECT_NAME,
	BUDGET
FROM
	PROJECTS
ORDER BY
	BUDGET DESC
LIMIT
	1;


--23) Find departments without employees
SELECT
	D.DEPT_ID,
	D.DEPT_NAME,
	D.LOCATION
FROM
	DEPARTMENTS AS D
	LEFT JOIN EMPLOYEES AS E ON D.DEPT_ID = E.DEPT_ID
WHERE
	E.EMP_ID IS NULL;


--24)Find employee hired earliest
SELECT
	EMP_ID,
	FIRST_NAME,
	LAST_NAME,
	HIRE_DATE
FROM
	EMPLOYEES
ORDER BY
	HIRE_DATE ASC
LIMIT
	1;


--25)Find total salary expenditure
SELECT
	SUM(SALARY) AS TOTAL_SALARY_EXPENDITURE
FROM
	EMPLOYEES;
