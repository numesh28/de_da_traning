/*You’re given a dataset containing employee names, departments, and their salaries.
 Your task is to rank the employees by salary within each department and classify them as:
"High Growth" if the salary is higher than the previous person in that department
"Low Growth" if the salary is lower
"No Growth" if the salary is the same or it's the first employee in the department

Data (Input Schema)
data = [
  ("John", "HR", 60000),
  ("Jane", "HR", 65000),
  ("Jake", "HR", 60000),
  ("Alice", "IT", 80000),
  ("Bob", "IT", 90000),
  ("Charlie", "IT", 85000),
]
columns = ["name", "department", "salary"]*/

create table emp(name varchar(20), department varchar (20), salary float)

insert into emp values('John', 'HR', 60000),
  ('Jane', 'HR', 65000),
  ('Jake', 'HR', 60000),
  ('Alice', 'IT', 80000),
  ('Bob', 'IT', 90000),
  ('Charlie', 'IT', 85000)

select * from emp

WITH ranked_emp AS (
    SELECT
        name,
        department,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary) AS rn,
        LAG(salary, 1, NULL) OVER (PARTITION BY department ORDER BY salary) AS prev_salary
    FROM emp
),
growth_classification AS (
    SELECT
        name,
        department,
        salary,
        CASE
            WHEN prev_salary IS NULL THEN 'No Growth'
            WHEN salary > prev_salary THEN 'High Growth'
            WHEN salary < prev_salary THEN 'Low Growth'
            ELSE 'No Growth'
        END AS growth_status
    FROM ranked_emp
)
SELECT * FROM growth_classification ORDER BY department, salary;