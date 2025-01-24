/*
Question: What skills are required the top-paying data analyst jobs?
- Using the top 10 highest-paying Data Analyst role from the first query
- Add specific skills required for these roles.
*/

WITH highest_paying AS (
    SELECT
        job_id,
        job_title AS title,
        company_dim.name AS Company,
        salary_year_avg AS yearly_salary,
        job_location AS location
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
    LIMIT 10
)

SELECT 
    highest_paying.*,
    skills
FROM highest_paying
INNER JOIN skills_job_dim ON highest_paying.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id;

/*
INSIGHTS:
The top 3 most common skills mentioned for the highest-paying Data Analyst roles in 2023 from India:
- SQL: 6 occurrences
- Python: 5 occurrences
- AWS: 4 occurrences
- Other skills like Oracle and Spark are also in demand.
*/