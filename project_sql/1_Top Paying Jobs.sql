/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available in India.
- Focuses on job postings with specified salaries (removing any NULLs).
*/

SELECT
    job_id,
    job_title AS title,
    company_dim.name AS Company,
    salary_year_avg AS yearly_salary,
    job_location AS location,
    job_schedule_type,
    job_posted_date::date
FROM
    job_postings_fact
LEFT JOIN
    company_dim
ON
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_location LIKE '%India' 
    AND salary_year_avg IS NOT NULL
    AND job_title_short LIKE '%Data Analyst%'
ORDER BY
    salary_year_avg DESC
LIMIT 10;

/*
INSIGHTS:
- The most popular location in the Top 10 highest-paying jobs is Hyderabad in Telangana, India.
- The salaries range from 119k to 178k.
*/
