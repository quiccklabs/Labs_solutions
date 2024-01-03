
### Activity: Filter a SQL query




```bash
SELECT device_id, operating_system
FROM machines;


SELECT device_id, operating_system
FROM machines
WHERE operating_system = 'OS 2';


SELECT *
FROM employees
WHERE department = 'Finance';


SELECT *
FROM employees
WHERE department = 'Sales';



SELECT *
FROM employees
WHERE office = 'South-109';


SELECT *
FROM employees
WHERE office LIKE 'South%';
```


### Congratulation !!!
