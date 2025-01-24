### _Table Of Contents_
- [Introduction](#introduction)
- [Project Background](#project-background)
- [Tools I Used](#tools-i-used)
- [The Analysis](#the-analysis)
- [What I Learned](#what-i-learned)
- [Conclusions](#conclusions)



# Introduction
As a Data Analyst newbie, I was looking to put my newly-learned skills to the test by building this project that dives into the job market, specifically with respect to Data Analyst roles, and how these jobs fare in terms of demand and compensation. 📊💼

🔍 **Check out the SQL queries here:** [project_sql folder](/project_sql/)


# Project Background
The data used in this project was part of [Luke Barousse's](https://www.lukebarousse.com/sql) course _'SQL for Data Analytics'_. 

### The questions I wanted to answer through this project were:
1. What are the top-paying data analyst jobs?
2. What skills are required the top-paying data analyst jobs?
3. What are the most in-demand skills for data analysts?
4. What is the demand to salary comparison for data analyst roles?
5. What are the optimal (high in-demand & highly paid) skills to learn?


# Tools I Used
- SQL
- PostgreSQL
- Visual Studio Code
- Git & GitHub


# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on India. 

```sql
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
```
---
**Here are the insights I gained from this:**
- The most popular location in the Top 10 highest-paying jobs is Hyderabad in Telangana, India.
- The salaries range from 119k to 178k.
---


### 2. Skills Required for Top Paying Jobs
To understand what skills are required for the top-paying jobs in India, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
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
```
---
**Here are the insights I gained from this:**
- The top 3 most common skills mentioned for the highest-paying Data Analyst roles in 2023 from India:
    - SQL: 6 occurrences
    - Python: 5 occurrences
    - AWS: 4 occurrences
- Other skills like Oracle and Spark are also in demand.
---


### 3. In-Demand Data Analyst Skills
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
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
```
**_Most Sought-After Data Analyst Skills:_**

| Skills      | Job Count |
|-------------|-----------|
| sql         | 92,628    |
| excel       | 67,031    |
| python      | 57,326    |
| tableau     | 46,554    |
| power bi    | 39,468    |
| r           | 30,075    |
| sas         | 28,068    |
| powerpoint  | 13,848    |
| word        | 13,591    |
| sap         | 11,297    |
---
**Here are the insights I gained from this:**
- SQL is the most sought-after skill for Data Analsyts with almost 100k job postings for it.
- It is closely followed by Excel and Python, as the top 3 skills in demand.
- Other skills in the top 10 include Tableau, Power BI and R.
---

### 4. Salary-Skill Comparison
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

First, I looked into the average salaries for the most sought-after jobs from the previous queries.

```sql
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
```
**_Average Salary for In-Demand Skills:_**

| Skills      | Average Salary |
|-------------|----------------|
| sql         | 96,435         |
| excel       | 86,419         |
| python      | 101,512        |
| tableau     | 97,978         |
| r           | 98,708         |
| power bi    | 92,324         |
| sas         | 93,707         |
| word        | 82,941         |
| powerpoint  | 88,316         |
| sql server  | 96,191         |



Now, let's look into the skills that are the most financially rewarding.

```sql
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
```
**_Average Salary for Highest-Paying Skills:_**

| Skills     | Average Salary |
|------------|----------------|
| svn        | 400,000        |
| solidity   | 179,000        |
| couchbase  | 160,515        |
| datarobot  | 155,486        |
| golang     | 155,000        |
| mxnet      | 149,000        |
| dplyr      | 147,633        |
| vmware     | 147,500        |
| terraform  | 146,734        |
| twilio     | 138,500        |

---

**Here are the insights I gained from this:**
- Among the most demanded skills for Data Analysts, Python pays the most with an average salary of 101k.
- It is followed by R, Tableau and SQL.
- The most financially rewarding skills are SVN, Solidity, Couchbase, DataRobot and Golang.
- However, these figures may not fully reflect the typical earnings, as they are based on averages and could be skewed by outliers,such as a single job posting offering $400k for an SVN-related position.
---
### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, both in India and worldwide, offering a strategic focus for skill development.

First, I looked into data from India, with a lower limit of 10 for the job count.

```sql
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
```

**_Optimal Skills To Learn in India:_**

| Skill ID | Skills    | Job Count | Average Salary |
|----------|-----------|-----------|----------------|
| 92       | spark     | 11        | 118,332        |
| 183      | power bi  | 17        | 109,832        |
| 79       | oracle    | 11        | 104,260        |
| 74       | azure     | 15        | 98,570         |
| 1        | python    | 36        | 95,933         |
| 76       | aws       | 12        | 95,333         |
| 182      | tableau   | 20        | 95,103         |
| 0        | sql       | 46        | 92,984         |
| 181      | excel     | 39        | 88,519         |
| 5        | r         | 18        | 86,609         |



Now, let's look at worldwide data. 

```sql
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
```

**_Optimal Skills To Learn Worldwide:_**

| Skill ID | Skills      | Job Count | Average Salary |
|----------|-------------|-----------|----------------|
| 98       | kafka       | 40        | 129,999        |
| 101      | pytorch     | 20        | 125,226        |
| 31       | perl        | 20        | 124,686        |
| 99       | tensorflow  | 24        | 120,647        |
| 63       | cassandra   | 11        | 118,407        |
| 219      | atlassian   | 15        | 117,966        |
| 96       | airflow     | 71        | 116,387        |
| 3        | scala       | 59        | 115,480        |
| 169      | linux       | 58        | 114,883        |
| 234      | confluence  | 62        | 114,153        |

---
**Here are the insights I gained from this:**

_For Data Analyst Roles in India:_

- SQL, Excel, and Python dominate job postings but offer moderate pay, reflecting their widespread use and competition.
- Skills like Spark, Power BI, and Oracle command higher salaries, despite having fewer opportunities.
- Skills like Tableau and Power BI strike a balance between demand and pay, making them valuable additions to a data analyst's toolkit.


_For Data Analyst Roles Worldwide:_

- Kafka, PyTorch and TensorFlow lead in average salaries, reflecting the value of expertise in machine learning and real-time data processing.
- Skills like Airflow, Scala, and Linux show a strong demand paired with competitive salaries.
- Tools such as Cassandra, Atlassian, and Confluence offer notable salaries but have lower job counts, suggesting targeted demand for professionals proficient in these.


# What I Learned

- 🧩 **Advanced SQL:** Skilled in merging tables and using WITH clauses for efficient temporary tables.
- 📊 **Data Aggregation:** Experienced with GROUP BY and aggregate functions like COUNT() and AVG() for summarizing data.
- 💡 **Analytical Expertise:** Able to turn complex questions into clear, actionable SQL queries.

# Conclusions

From the analysis, several insights emerged:

1. **Popular Locations and Skills in India:** Hyderabad stands out as the top location for high-paying Data Analyst jobs in India, with SQL, Python, and AWS being the most sought-after skills, while other tools like Oracle, Spark, Tableau, and Power BI also have significant demand.

2. **Salary Insights:** Salaries for Data Analyst roles in India range from $119k to $178k, with Python offering the highest pay, while skills like SQL, Excel, and Tableau offer moderate salaries. On a global scale, machine learning-related skills like Kafka and PyTorch lead in salaries.

3. **Skill Demand and Pay Balance:** Skills such as SQL, Excel, and Python are in high demand but offer moderate pay due to their widespread use, while specialized skills like Spark, Power BI, and Oracle offer higher salaries but fewer job opportunities.

### Closing Thoughts

This project improved my SQL skills and offered valuable insights into the data analyst job market. The analysis helps prioritize skill development and job search strategies, emphasizing the importance of focusing on high-demand, high-salary skills. It underscores the need for continuous learning and adapting to industry trends.