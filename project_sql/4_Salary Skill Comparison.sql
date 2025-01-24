/*
Question: 
    A. What is the average salary associated with the top 10 skills? 
    B. What are the top skills based on salary?
- Not restricted by location
- 'A' gives us the expected salary for the most-sought after skills
- 'B' helps identify the most financially rewarding skills to acquire
*/

-- Average Salary Associated with Top 10 Skills for a Data Analyst
SELECT 
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE (job_title_short = 'Data Analyst') AND job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY skills_dim.skills
ORDER BY COUNT(job_postings_fact.job_id) DESC
LIMIT 10;

-- Skills With the Highest Average Salaries
SELECT 
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE (job_title_short = 'Data Analyst') AND job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY skills_dim.skills
ORDER BY average_salary DESC
LIMIT 10;

/*
INSIGHTS:
- Among the most demanded skills for Data Analysts, Python pays the most with an average salary of 101k.
- It is followed by R, Tableau and SQL.
- The most financially rewarding skills are SVN, Solidity, Couchbase, DataRobot and Golang.
- However, these figures may not fully reflect the typical earnings, as they are based on averages and 
  could be skewed by outliers,such as a single job posting offering $400k for an SVN-related position.
*/