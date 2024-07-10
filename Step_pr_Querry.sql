-- 1. Покажіть середню зарплату співробітників за кожен рік, до 2005 року
SELECT year(from_date) as Period, round(avg(salary), 0) as Average_sal
FROM (SELECT* FROM employees.salaries
    UNION ALL
        SELECT 0, 0, '2003-01-01', '2003-12-31'
    UNION ALL
        SELECT 0, 0, '2004-01-01', '2004-12-31'
    UNION ALL
        SELECT 0, 0, '2005-01-01', '2005-12-31') AS fin
GROUP BY year(from_date)
ORDER BY year(from_date);

-- 2. Покажіть середню зарплату співробітників по кожному відділу. Примітка: потрібно
-- розрахувати по поточній зарплаті, та поточному відділу співробітників
SELECT ed.dept_name as Departments, round(AVG(salary), 0) as Average_salary
FROM employees.salaries AS es
JOIN employees.dept_emp AS ede ON (es.emp_no = ede.emp_no)
JOIN employees.departments AS ed ON (ede.dept_no = ed.dept_no)
WHERE now() BETWEEN es.from_date AND es.to_date AND now() BETWEEN ede.from_date AND ede.to_date
GROUP BY ed.dept_name
ORDER BY AVG(salary);
-- або

SELECT DISTINCT ed.dept_name, round(avg(es.salary) OVER(PARTITION BY ed.dept_name), 0) AS avg_sal
FROM employees.salaries AS es
JOIN employees.dept_emp AS ede ON (es.emp_no = ede.emp_no)
JOIN employees.departments AS ed ON (ede.dept_no = ed.dept_no)
WHERE now() BETWEEN es.from_date AND es.to_date AND now() BETWEEN ede.from_date AND ede.to_date
ORDER BY avg_sal;

-- 3. Покажіть середню зарплату співробітників по кожному відділу за кожний рік
SELECT ed.dept_no, ed.dept_name as Departments, year(es.from_date) AS Year, round(AVG(salary), 0) as Average_salary
FROM employees.salaries AS es
JOIN employees.dept_emp AS ede ON (es.emp_no = ede.emp_no)
JOIN employees.departments AS ed ON (ede.dept_no = ed.dept_no)
GROUP BY ed.dept_no, ed.dept_name, year(es.from_date)
ORDER BY ed.dept_no, ed.dept_name;


-- 4. Покажіть відділи в яких зараз працює більше 15000 співробітників.
SELECT ede.dept_no, ed.dept_name, count(ede.emp_no) 
FROM  employees.departments AS ed
JOIN employees.dept_emp AS ede ON (ede.dept_no = ed.dept_no) AND now() BETWEEN ede.from_date AND ede.to_date
GROUP BY ede.dept_no, ed.dept_name
HAVING count(emp_no)> 15000 
ORDER BY count(ede.emp_no);


-- 5. Для менеджера який працює найдовше покажіть його номер, відділ, дату прийому на
-- роботу, прізвище
SELECT edm.emp_no, edm.dept_no, ed.dept_name, ee.hire_date, ee.last_name, timestampdiff(year, edm.from_date, now()) AS Term
FROM employees.dept_manager AS edm
JOIN employees.departments AS ed ON (edm.dept_no = ed.dept_no)
JOIN employees.employees AS ee ON (edm.emp_no = ee.emp_no)
WHERE now() BETWEEN edm.from_date AND edm.to_date
ORDER BY timestampdiff(year, edm.from_date, now()) DESC
LIMIT 1;

-- 6. Покажіть топ-10 діючих співробітників компанії з найбільшою різницею між їх зарплатою і
-- середньою зарплатою в їх відділі. 
SELECT ee.emp_no, ede.dept_no, ed.dept_name, salary, round(AVG(salary) OVER (PARTITION BY ed.dept_name),0) as avg_sal, salary - round(AVG(salary) OVER (PARTITION BY ed.dept_name),0) as difference
FROM employees.employees AS ee
JOIN employees.dept_emp AS ede ON (ee.emp_no = ede.emp_no)
JOIN employees.departments AS ed ON (ede.dept_no = ed.dept_no)
JOIN employees.salaries AS es ON (ee.emp_no = es.emp_no)
WHERE now() BETWEEN es.from_date AND es.to_date AND now() BETWEEN ede.from_date AND ede.to_date
ORDER BY difference desc
LIMIT 10;

-- 7. Для кожного відділу покажіть другого по порядку менеджера. Необхідно вивести відділ,
-- прізвище ім’я менеджера, дату прийому на роботу менеджера і дату коли він став
-- менеджером відділу ;

SELECT ed.dept_name, ee.first_name, ee.last_name, ee.hire_date, fin.from_date, man_nm
FROM (
SELECT *, RANK() OVER (PARTITION BY dept_no ORDER BY from_date) AS man_nm
FROM employees.dept_manager) AS fin
JOIN employees.employees AS ee ON (ee.emp_no = fin.emp_no)
JOIN employees.departments AS ed ON (fin.dept_no = ed.dept_no)
WHERE man_nm = 2;

