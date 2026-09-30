--subquery

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL 
    OR salary_hour_avg IS NOT NULL
)
LIMIT 10;

--ctes

WITH valid_salaries AS (
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL 
    OR salary_hour_avg IS NOT NULL
)
SELECT *
FROM valid_salaries;

-- select subquery

SELECT 
    job_title_short,
    salary_year_avg,
    (
    SElECT MEDIAN(salary_year_avg),
    FROM job_postings_fact
) AS market_median_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;


-- from subquery 

SELECT 
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
    SElECT MEDIAN(salary_year_avg),
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS market_median_salary
FROM (
    SELECT 
    job_title_short,
    salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS clean_jobs
GROUP BY job_title_short
LIMIT 10;


-- having subquery


SELECT 
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
    SElECT MEDIAN(salary_year_avg),
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS market_remote_median_salary
FROM (
    SELECT 
    job_title_short,
    salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS clean_jobs
GROUP BY job_title_short
HAVING MEDIAN(salary_year_avg) >  (SElECT MEDIAN(salary_year_avg),
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE)
LIMIT 10;



--ctes

WITH title_median (
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT AS median_salary,
    FROM job_postings_fact
    WHERE job_country = 'United States'
    GROUP BY job_title_short,
            job_work_from_home;
)