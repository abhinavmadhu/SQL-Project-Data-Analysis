/*
Question: What are the most in-demand skills for data analysts?
- Focuses on the most sought-after skills for the role
- Not limited by location
*/

SELECT 
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS job_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills_dim.skills
ORDER BY job_count DESC
LIMIT 10;

/*
INSIGHTS:
- SQL is the most sought-after skill for Data Analsyts with almost 100k job postings for it.
- It is closely followed by Excel and Python, as the top 3 skills in demand.
- Other skills in the top 10 include Tableau, Power BI and R.
*/