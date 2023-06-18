CREATE DATABASE projects;

USE projects;

SELECT * FROM hr;

ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

DESCRIBE hr;

SELECT birthdate FROM hr;

SET sql_safe_updates = 0;

UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE'%/%'THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
	WHEN hire_date LIKE'%-%'THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
	ELSE NULL
END;
    
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE'%/%'THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
	WHEN hire_date LIKE'%-%'THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
	ELSE NULL
END;

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT termdate from hr;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

ALTER TABLE hr
ADD COLUMN age INT;

Update hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT
	min(age) AS youngest,
    max(age) AS oldest
FROM hr;


SELECT COUNT(*) FROM hr WHERE age < 18;

UPDATE hr
SET hire_date = IF(hire_date IS NOT NULL AND hire_date != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT hire_date from hr;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

SELECT birthdate,age FROM hr;

SELECT * FROM hr;

-- Gender distribution within the company--
SELECT gender, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = 000-00-00
GROUP BY gender;
-- Race/Ethnicity Breakdown of Company--
Select race, COUNT(*) AS count
From hr
WHERE age >=18 AND termdate = 000-00-00
GROUP BY race
ORDER BY count(*) DESC;
-- Age distribution of Company --
SELECT
	min(age) AS youngest,
    max(age) AS oldest
FROM hr
WHERE age >=18 AND termdate = 000-00-00;

SELECT
	CASE
		WHEN age >= 18 AND age <=24 THEN '18-24'
        WHEN age >= 25 AND age <=34 THEN '25-34'
        WHEN age >= 35 AND age <=44 THEN '35-44'
        WHEN age >= 45 AND age <=54 THEN '45-54'
        WHEN age >= 55 AND age <=64 THEN '55-64'
        ELSE '65+'
END AS age_group,
count(*) AS count
FROM hr
WHERE age >=18 AND termdate = 000-00-00
GROUP BY age_group
ORDER BY age_group;


SELECT
	CASE
		WHEN age >= 18 AND age <=24 THEN '18-24'
        WHEN age >= 25 AND age <=34 THEN '25-34'
        WHEN age >= 35 AND age <=44 THEN '35-44'
        WHEN age >= 45 AND age <=54 THEN '45-54'
        WHEN age >= 55 AND age <=64 THEN '55-64'
        ELSE '65+'
END AS age_group, gender,
count(*) AS count
FROM hr
WHERE age >=18 AND termdate = 000-00-00
GROUP BY age_group, gender
ORDER BY age_group, gender;
-- Employees that work at headquarters vs remote locations
SELECT location, count(*) AS count
FROM hr
WHERE age >=18 AND termdate = 000-00-00
GROUP BY location;
-- Gender distribution variation across departments and job titles--
SELECT department, gender, COUNT(*) AS COUNT
FROM hr
WHERE age >=18 AND termdate = 000-00-00
GROUP BY department, gender
ORDER BY department;

-- Distribution of job titles across the company
SELECT jobtitle, count(*) AS count
FROM hr
WHERE age >=18 AND termdate = 000-00-00
GROUP BY jobtitle
ORDER BY jobtitle desc;


 -- Department with highest turnover rate--
 Select department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
    FROM (
	 SELECT department,
     count(*) AS total_count,
     SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
	FROM hr
    WHERE age >= 18
    GROUP BY department
    ) AS subquery
ORDER BY termination_rate DESC;
 
 -- Distribution of employees across locations by city and state
 SELECT location_state, COUNT(*) AS count
 FROM hr
 WHERE age >=18 AND termdate = 000-00-00
 GROUP BY location_state
 ORDER BY count DESC;
 
 -- Employee count change over time based on hire and term dates
 SELECT
	year,
    hires,
    terminations,
    hires - terminations AS net_change,
    round((hires - terminations)/hires*100,2) AS net_change_percent
FROM(
	SELECT 
	 year(hire_date) AS year,
	 count(*) AS hires,
	 SUM(CASE WHEN termdate <> 0000-00-00 AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
	 FROM hr
     WHERE age >=18
     GROUP BY YEAR(hire_date)
     )AS subquery
ORDER BY year ASC;
    
 
 -- Tenure distribution within each department
 SELECT department, round(avg(datediff(termdate, hire_date)/365),0) AS avg_tenure
 FROM hr
 WHERE termdate <= curdate() AND termdate<> '0000-00-00' AND age >=18
 GROUP by department;
 
 -- Delete last two items along with this