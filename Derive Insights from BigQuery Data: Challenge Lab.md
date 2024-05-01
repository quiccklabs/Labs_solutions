# Derive Insights from BigQuery Data: Challenge Lab

Make sure you changing all the dates and count as per the task.

## Task 1. Total confirmed cases

```sql
SELECT sum(cumulative_confirmed) as total_cases_worldwide
FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE date='2020-05-25'
```

## Task 2. Worst affected areas

```sql
WITH deaths_by_states AS (
    SELECT subregion1_name as state, sum(cumulative_deceased) as death_count
    FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
    WHERE country_name="United States of America" and date='2020-04-10' and subregion1_name is NOT NULL
    GROUP BY subregion1_name
)
SELECT count(*) as count_of_states
FROM deaths_by_states
WHERE death_count > 300
```

## Task 3. Identify hotspots

```sql
SELECT * FROM (
    SELECT subregion1_name as state, sum(cumulative_confirmed) as total_confirmed_cases
    FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
    WHERE country_code="US" AND date='2020-04-10' AND subregion1_name is NOT NULL
    GROUP BY subregion1_name
    ORDER BY total_confirmed_cases DESC
)
WHERE total_confirmed_cases > 3000
```

## Task 4. Fatality ratio

```sql
SELECT sum(cumulative_confirmed) as total_confirmed_cases,
       sum(cumulative_deceased) as total_deaths,
       (sum(cumulative_deceased)/sum(cumulative_confirmed))*100 as case_fatality_ratio
FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE country_name="Italy" AND date BETWEEN '2020-05-01' and '2020-05-31'
```

## Task 5. Identifying specific day

```sql
SELECT date
FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE country_name="Italy" and cumulative_deceased>16000
ORDER BY date asc
LIMIT 1
```

## Task 6. Finding days with zero net new cases

```sql
WITH india_cases_by_date AS (
    SELECT date, SUM(cumulative_confirmed) AS cases
    FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
    WHERE country_name ="India" AND date BETWEEN '2020-02-23' AND '2020-03-11'
    GROUP BY date
    ORDER BY date ASC
), india_previous_day_comparison AS (
    SELECT date, cases, LAG(cases) OVER(ORDER BY date) AS previous_day, cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases
    FROM india_cases_by_date
)
SELECT count(*)
FROM india_previous_day_comparison
WHERE net_new_cases=0
```

## Task 7. Doubling rate

```sql
WITH us_cases_by_date AS (
    SELECT date, SUM(cumulative_confirmed) AS cases
    FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
    WHERE country_name="United States of America" AND date BETWEEN '2020-03-22' AND '2020-04-20'
    GROUP BY date
    ORDER BY date ASC
), us_previous_day_comparison AS (
    SELECT date, cases, LAG(cases) OVER(ORDER BY date) AS previous_day,
           cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases,
           (cases - LAG(cases) OVER(ORDER BY date))*100/LAG(cases) OVER(ORDER BY date) AS percentage_increase
    FROM us_cases_by_date
)
SELECT Date, cases AS Confirmed_Cases_On_Day, previous_day AS Confirmed_Cases_Previous_Day, percentage_increase AS Percentage_Increase_In_Cases
FROM us_previous_day_comparison
WHERE percentage_increase > 5
```

## Task 8. Recovery rate

```sql
WITH cases_by_country AS (

  SELECT

    country_name AS country,

    sum(cumulative_confirmed) AS cases,

    sum(cumulative_recovered) AS recovered_cases

  FROM

    bigquery-public-data.covid19_open_data.covid19_open_data

  WHERE

    date = '2020-05-10'

  GROUP BY

    country_name

 )

, recovered_rate AS

(SELECT

  country, cases, recovered_cases,

  (recovered_cases * 100)/cases AS recovery_rate

FROM cases_by_country

)
SELECT country, cases AS confirmed_cases, recovered_cases, recovery_rate

FROM recovered_rate

WHERE cases > 50000

ORDER BY recovery_rate desc

LIMIT 20 

```

## Task 9. CDGR - Cumulative daily growth rate

```sql
WITH france_cases AS (
    SELECT date, SUM(cumulative_confirmed) AS total_cases
    FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
    WHERE country_name="France" AND date IN ('2020-01-24', '2020-04-10')
    GROUP BY date
    ORDER BY date
), summary AS (
    SELECT total_cases AS first_day_cases, LEAD(total_cases) OVER(ORDER BY date) AS last_day_cases,
           DATE_DIFF(LEAD(date) OVER(ORDER BY date), date, day) AS days_diff
    FROM france_cases
    LIMIT 1
)
SELECT first_day_cases, last_day_cases, days_diff,
       POWER((last_day_cases/first_day_cases),(1/days_diff))-1 AS cdgr
FROM summary
```

## Task 10. Create a Looker Studio report

```sql
SELECT date, SUM(cumulative_confirmed) AS country_cases,
       SUM(cumulative_deceased) AS country_deaths
FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE date BETWEEN '2020-03-20' AND '2020-04-23'
  AND country_name ="United States of America"
GROUP BY date
```


##         ```     Congratulation!!!```
