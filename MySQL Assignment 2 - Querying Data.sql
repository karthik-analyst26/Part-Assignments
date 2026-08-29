-- =====================================================================================
-- 	EMPLOYEE DATABASE ASSIGNMENT
-- Data insertion, Querying, Filtering, Aggregation, Joins, Window Functions
-- ====================================================================================

 -- SELECT THE DATABASE 
 USE EMPLOYEE;

select * from employees ;

select * from departments ;

select * from location ;
-- --------------------------------------------------------------------------------------
-- Insert values to Departments Table

insert into departments (
	department_id, department_name)
    values
		(1, 'Finance'),
        (2, 'Human Resource'),
        (3, 'IT'),
        (4, 'Marketing'),
        (5, 'Sales') ;
        
-- Insert values to Location Table

insert into location (
	location_id, location_name)
    values
		(1, 'Chennai'),
        (2, 'Bangalore'),
        (3, 'Mumbai'),
        (4, 'Delhi') ;

-- Insert Values to Employees Table

insert into employees (
	employee_id, Employee_Name, Gender, Age, Hire_Date, Designation, Salary, department_id, location_id)
    values
	  (101, 'Ravi Kumar',   'M',   29, '2015-06-12', 'Data Analyst',      55000, 1, 1),
      (102, 'Priya Sharma', 'F', 26, '2018-03-20', 'HR Executive',      42000, 2, 2),
      (103, 'Arun Das',     'M',   34, '2014-11-01', 'Software Engineer', 72000, 3, 3),
      (104, 'Sneha Iyer',   'F', 28, '2018-07-15', 'Marketing Analyst', 48000, 4, 4),
      (105, 'Vikram Rao',   'M',   31, '2016-01-10', 'Sales Executive',   51000, 5, 1),
      (106, 'Anjali Nair',  'F', 24, '2018-09-05', NULL ,                39000, 3, 2),
      (107, 'Karthik S',    'M',   45, '2010-04-22', 'Finance Manager',   95000, 1, 3),
      (108, 'Divya Menon',  'F', 27, '2018-02-18', 'Business Analyst',  53000, 3, 4);
      
      drop table employees ;
-- =============================================================================================================
-- SECTION 1: CLAUSES & OPERATORS
-- ============================================================================================================

-- 1.1 DISTINCT VALUES
-- Retrieve distinct (Unique) salary values from Employees

select distinct salary from employees ;

-- 1.2 ALIAS (AS)
-- Rename Age and Salary columns in the output using alias

select Employee_Name,
	age as Employee_Age,
    salary as Employee_Salary
    from employees ;
    
-- 1.3 WHERE CLAUSE & OPERATIONS
-- Employee with Salary > 50000 and hired before 2016-01-01

select * from employees 
	where salary > 50000
    and hire_date < '2016-01-01' ;
    
-- Find employee with Missing Designation and Update it with "Data Scientist"
-- step 1: Identify The Null

select * from employees
	where designation is Null ;

-- step 2: Fill Missing Designation with "Data Scientist"

update employees set designation = ' Data Scientist'
	where designation is null ;

-- ==================================================================================
-- SECTION 2: SORTING AND GROUPING DATA
-- ===================================================================================

-- 2.1 ORDER BY
-- Employees sorted by Department_id ascending, then Salary in Descending

select * from employees
	order by department_id asc , salary desc ;
    
-- 2.2 LIMIT
-- First 5 Employees Hired in the Year 2018

select * from employees 
	where year(hire_date) = 2018
    order by hire_date
    limit 5 ;
    
-- 2.3 AGGREGATE FUNCTIONS
-- Sum of all Salaries in the Finance Department

select sum(e.salary) as Total_Finance_Salary
	from employees e
    join departments d on e.department_id = d.department_id
    where d.department_name = 'Finance' ; 

-- Minimum Age Among All Employees

select min(age) as Minimum_Age
	from employees ;

-- 2.4 GROUP BY
-- Maximum Salary For Each Location

select l.location_name, max(e.salary) as Max_salary
	from employees e 
    join location l on e.location_id = l.location_id 
    group by l.location_name ; 

-- Average Salary For Each Designation Containing the Word 'Analyst'

select designation, avg(salary) as Average_Salary
	from employees
    where designation like '%Analyst%'
    group by designation ; 
    
-- 2.5 HAVING
-- Departments with Less Than 3 Employees

select d.department_name, count(e.employee_id) as Employee_Count
	from departments d
    left join employees e on d.department_id = e.department_id
    group by d.department_name
    having count(e.employee_id) < 3 ;
    
-- Locations with Female Employees Whose Average Age is Below 30

select l.location_name, avg(e.age) as Average_Female_Age
	from employees e 
    join location l on e.location_id = l.location_id
    where e.gender = 'F'
    group by l.location_name
    having avg(e.age) < 30 ;

-- ==========================================================================================
-- SECTION 3 : JOINS
-- ==========================================================================================

-- 3.1 INNER JOIN
-- Employee Names, Designations and Department Names
-- (Only Employees that are Assigned to a Department)

select e.employee_name, e.designation, d.department_name
	from employees e 
    inner join departments d on e.department_id = d.department_id ; 
    
-- 3.2 LEFT JOIN 
-- All Departments With Total Employee Count, Including Departments with No Employees

select d.department_name, count(e.employee_id) as Total_Employees
	from departments d 
    left join employees e on d.department_id = e.department_id
    group by d.department_name ; 
    
-- 3.3 RIGHT JOIN
-- All Locations with Employee Names, NULL shown if No Employee is Assigned

select l.location_name, e.employee_name
	from employees e 
    right join location l on e.location_id = l.location_id ;

-- 3.4 CROSS JOIN
-- Every Possible Combination of Departments and Locations

select d.department_name, l.location_name
	from departments d
    cross join location l ;

-- 3.5 SELF JOIN
-- Pairs of Employees Working in the Same Department, Excluding Self-Pairs

select 
	e1.employee_name as employee_1,
    e2.employee_name as employee_2,
    e1.department_id
from employees e1
join employees e2
	on e1.department_id = e2.department_id
    and e1.employee_id < e2.employee_id ;               -- Avoids Self-Paring and Duplicate Reversed Pairs
    
-- ===========================================================================================================
-- SECTION 4 : WINDOW FUNCTIONS
-- =======================================================================================================

-- 4.1 Rank Employees by Salary (Overall) using Rank()

select employee_name, salary, 
	rank() over (order by salary desc) as Salary_Rank
from employees ;

-- 4.2 Rank Employees by Salary within Each Department Using DENSE_RANK()

select employee_name, department_id, salary,
	dense_rank() over (partition by department_id order by salary desc)
    as Dept_Salary_Rank
from employees ;

-- 4.3 Running Total of Salary by Department

select employee_name, department_id, salary, 
	sum(salary) over (partition by department_id order by employee_id
		rows between unbounded preceding and current row)
        as Running_Total_Salary
from employees ;

-- ===========================================================================================================
-- ===========================================================================================================
-- =========================================================================================================

































    



















        






























