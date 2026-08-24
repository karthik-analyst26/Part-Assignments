-- PROJECT: Employee Management Database
-- PART 1: DDL COMMANDS

-- ---------------------------------------------------
-- 1. DATABASE AND TABLE CREATION
-- --------------------------------------------------

-- CREATE THE DATABASE FOR THE PROJECT
 CREATE DATABASE IF NOT exists employee;
 
 -- SELECT THE DATABASE TO WORK insert
 USE 	EMPLOYEE;

-- CREATE THE DEPARTMENT TABLE
CREATE table DEPARTMENT (
  department_id INT primary key,                 -- Primary key uniquely Identifies each department
  department_name varchar(100)                   -- Name of the department
  );
  
  -- Create the Location Table 
  create table Location(
  location_id int primary key,                   -- primary key uniquely Identifies each Location
  location_name varchar(100)                     -- Name of the Location
  );
  
  -- Create the Employee Table with Foreign keys referencing Departments and Locations
  create table Employee (
  employee_id int primary key ,                   -- primary key uniquely identifies each employee
  Employee_name varchar(100),                     -- Name of the Employee
  Gender  enum('F','M'),                          -- Gender of the Employee
  Age  int ,                                      -- Age of the 
  Hire_date date,                                -- Date of the Employee was Hired
  Designation varchar(50),                        -- Job Title / Role of the Employee
  Salary decimal(10,2),                           -- Salary of the Employee
  department_id int,                             -- FK referencing Department Table
  location_id int,                                -- FK referencing Location Table
  
  constraint fk_emp_department
     foreign key (department_id) references Department(department_id),
     
  constraint fk_emp_Location
      foreign key(location_id) references Location(location_id)
);

-- ---------------------------------------------------------------------------
-- 2. TABLE ALTERATION (ALTER)
-- -----------------------------------------------------------------------------

-- Add a new "email" Column to store employee email addresses
alter table employee
        add column email varchar(150);
        
-- Widen the "Designation" column so it can hold longer Job Titles
alter table employee 
	modify column Designation varchar(100);
    
-- Drop the "Age" column from the Employee Table	
alter table employee
    drop column Age;
    
 -- Rename the "Hire_date" column to "date_of_joining"
 alter table employee
     rename column Hire_date to date_of_joining;
     
-- -----------------------------------------------------------------------------------------
-- 3. Table Renaming (RENAME)
-- -----------------------------------------------------------------------------------------

-- Rename the "Department" table to "Departments" Table to "Departments_info"
rename table department to Departments_info;

-- Rename the "Location" table to "Locations"
rename table location to Locations ;

   -- -----------------------------------------------------------------------------------------
   -- 4. Table Truncation (TRUNCATE)
   -- ----------------------------------------------------------------------------------------
   
-- Remove all rows from the Employee table but keep its structure
truncate table employee;

select * from employee ;

-- -----------------------------------------------------------------------------------------
-- 5. Database & Table Dropping (DROP)
-- -------------------------------------------------------------------------------------------

-- Drop the employee table completely

drop table employee ;
 
 select * from employee ;
 
 -- Drop the Entire employee database
 
 drop database employee;
 
 
 -- ===============================================================================================
 -- PART - 2: CONSTRAINTS TASK
 -- Drop and ReCreate the Database with full Constraints
 -- ================================================================================================
 
 -- ---------------------------------------------------------------------------------------------
 -- 1. Database Recreation
 -- ---------------------------------------------------------------------------------------------
 
 -- Drop the 'employee' database if it still exista
 drop database if exists employee ;
 
 -- Recreate the database
 create database employee ;
 
 -- Switch to the New Database
 use employee ; 
 
 
 -- ------------------------------------------------------------------------------------------------
 -- 2. Department Table (with Constraints)
 -- ------------------------------------------------------------------------------------------------
 
 create table departments (
       department_id int primary key,                     -- uniquely identifies each department
       department_name varchar(100) not null unique        -- No Null and No Duplicate Department Names
) ;

-- -----------------------------------------------------------------------------------------------------
-- 3. Locations Table (With Constraints)
-- -----------------------------------------------------------------------------------------------------

create table Locations (
      location_id int auto_increment primary key ,    -- Auto-generated, Sequentially incremented UNique ID
      location_name varchar(100) not null unique      -- No Null and No Duplicate Location Name
) ;

-- --------------------------------------------------------------------------------------------------------
-- 4. Employees Table (With Constraints)
-- --------------------------------------------------------------------------------------------------------

create table employees (
      employee_id    int auto_increment primary key,         -- Distinct Identifier for every Employee
      Employee_name  varchar(100) not null,                  -- Employee Name must always be provided
      Gender       enum ('F','M') ,                       -- Restrict Gender to 'F' or 'M' Only
      Age          int check (Age >= 18) ,                -- Employee Must be 18 Years or Above
      Hire_date   date default (current_date()),           -- Defaults to Today's Date if Not Specified
      Designation  varchar(100),                           -- Job Title / Role of the Employee
      Salary       decimal(10,2) ,                         -- Salary iof the Employee
      department_id   int ,                                -- FK Referencing Departments Table
      location_id     int ,                                -- FK Referencing Locations Table
      constraint fk_employees_departments
               foreign key (department_id) references Departments(department_id),
	  constraint fk_employees_locations
               foreign key (location_id) references Locations(location_id)
) ;


-- ==========================================================================================================
-- Data insert to tables
-- ==========================================================================================================

-- Insert Departments Tabkle Values
insert into departments (department_id, department_name) values
   (1, "Human Resources") ,
   (2, "Finance") ,
   (3, "Marketing") ,
   (4, "Operations") ,
   (5, "Information Technology") ;
   
select * from departments ;

-- Insert Locations Table Values
-- location_id is Auto-Increment, SO it's not Specified while Insert the Values to Table

insert into locations (location_name) values
      ('Chennai'),
      ('Bangalore'),
      ('Hyderabad'),
      ('Delhi') ,
      ('Mumbai') ,
      ('Cochin'),
      ('Kolkata') ,
      ('Haryana') ;
      
select * from locations ;

-- Insert Employees Table Values
-- employee_id is Auto-Increment, Hire_Date defaults to today's Date is it's not included

insert into employees
    (Employee_name, Gender, Age, Designation, Salary, department_id, location_id) values 
    ('Arun Kumar' , 'M', 28, 'Software Engineer', 55000.00, 5, 1),
    ('Priya Sharma', 'F', 25, 'HR Executive', 40000.00, 1, 2),
    ('Rahul Verma', 'M', 34, 'Finance Manager', 75000.00, 2, 3),
    ('Sneha Reddy', 'F', 23, 'Marketing Intern', 20000.00, 3, 4),
    ('Vikram Singh', 'M', 45, 'Operations Head', 90000.00, 4, 5),
    ('Anjali Nair',  'F', 29, 'Software Tester', 48000.00, 5, 6),
    ('Jenifar', 'F', 25, 'Marketing', 25000.00, 3, 7),
    ('Vishal Kannan', 'M', 28, 'Marketing', 35000.00, 3, 8) ;

select * from employees ;

-- insert employee with an explicit Hire_date instead of using the Default
insert into employees 
    (employee_name, Gender, age, Hire_date, Designation, salary, department_id, location_id ) values
    ('Vinothini', 'F', 22, '2026-08-21', 'HR Intern', 20000.00, 1, 6) ;

-- View All Tables Data

select * from departments ;

select * from locations ;

select * from employees ;

-- ================================================================================================
-- CONSTRAINT - VIOLATION TESTS (Each of these are Expected to Fail)
-- As proof that Each Constraint is being Enforced
-- ================================================================================================

-- Duplicate department_name (Unique Violation)
insert into departments (department_id, department_name) values
              (6, 'Finance') ;
              
-- Null Employee Name (Not Null Violation)
insert into employees (employee_name, gender, age) values 
              (Null, 'M', 35) ;
              
-- Invalid Gender Value (Check Violation)
insert into employees (employee_name, gender, age) values
              ('Hari', 'Z', 30) ;

-- Age Below 18 (Check Violation)
insert into employees (employee_name, gender, age) values
                ('Siva' , 'M', 17) ;

-- =======================================================================================================
-- ======================================================================================================