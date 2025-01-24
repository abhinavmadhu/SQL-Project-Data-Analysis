/*
Question: What are the optimal skills to learn (aka it's both high-demand and high-paying)
- Identifies the intersection of high skill and high salary for Data Analyst roles
- Condition: Atleast 10 job postings
- Two cases: 
    A. With location as India
    B. With no limits on location
*/


-- LOCATION: INDIA
WITH skills_demand AS (
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS job_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' 
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_location LIKE '%India'
    GROUP BY skills_dim.skill_id
), skills_pay AS (
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        (job_title_short = 'Data Analyst') 
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_location LIKE '%India'
    GROUP BY skills_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    job_count,
    average_salary
FROM 
    skills_demand
INNER JOIN skills_pay
ON skills_demand.skill_id = skills_pay.skill_id
WHERE job_count > 10
ORDER BY 
    average_salary DESC
LIMIT 10;


-- LOCATION: All locations
WITH skills_demand AS (
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS job_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' 
        AND job_postings_fact.salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
), skills_pay AS (
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        (job_title_short = 'Data Analyst') 
        AND job_postings_fact.salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    job_count,
    average_salary
FROM 
    skills_demand
INNER JOIN skills_pay
ON skills_demand.skill_id = skills_pay.skill_id
WHERE job_count > 10
ORDER BY 
    average_salary DESC
LIMIT 10;

/*
INSIGHTS:

For Data Analyst Roles in India:

1. SQL, Excel, and Python dominate job postings but offer moderate pay, reflecting their widespread use
   and competition.
2. Skills like Spark, Power BI, and Oracle command higher salaries, despite having fewer opportunities.
3. Skills like Tableau and Power BI strike a balance between demand and pay, making them valuable additions
   to a data analyst's toolkit.

For Data Analyst Roles Worldwide:

1. Kafk, PyTorch and TensorFlow lead in average salaries, reflecting the value of expertise in machine
   learning and real-time data processing.
2. Skills like Airflow, Scala, and Linux show a strong demand paired with competitive salaries.
3. Tools such as Cassandra, Atlassian, and Confluence offer notable salaries but have lower job counts,
   suggesting targeted demand for professionals proficient in these.