Complete each of the sets of steps below:

Task 1: Create a table partitioned by date.


CREATE OR REPLACE TABLE <dataset_name>.<table_name>
PARTITION BY date
OPTIONS(
partition_expiration_days=1080,
description="oxford_policy_tracker table in the COVID 19 Government Response public dataset with  an expiry time set to 90 days."
) AS
SELECT
   *
FROM
   `bigquery-public-data.covid19_govt_response.oxford_policy_tracker`
WHERE
   alpha_3_code NOT IN ('GBR', 'BRA', 'CAN','USA')


Task 2: Add new columns to your table.

Add the following columns using the Big Query console schema edit feature. Note that mobility is a record/struct with six child columns. 


Run the below Query:

ALTER TABLE <dataset_name>.<table_name>
ADD COLUMN population INT64,
ADD COLUMN country_area FLOAT64,
ADD COLUMN mobility STRUCT<
   avg_retail      FLOAT64,
   avg_grocery     FLOAT64,
   avg_parks       FLOAT64,
   avg_transit     FLOAT64,
   avg_workplace   FLOAT64,
   avg_residential FLOAT64
>


Task 3: Add country population data to the population column.
Populate the population column using data from the ECDC Covid19 geographic distribution public data set. 

BigQuery Console Query Editor
1st QUERY  -------------------------------------------------------------------

CREATE OR REPLACE TABLE <dataset_name>.pop_data_2019 AS
SELECT
  country_territory_code,
  pop_data_2019
FROM 
  `bigquery-public-data.covid19_ecdc.covid_19_geographic_distribution_worldwide`
GROUP BY
  country_territory_code,
  pop_data_2019
ORDER BY
  country_territory_code
  

2ND QUERY  -------------------------------------------------------------------

UPDATE
   `<dataset_name>.<table_name>` t0
SET
   population = t1.pop_data_2019
FROM
   `<dataset_name>.pop_data_2019` t1
WHERE
   CONCAT(t0.alpha_3_code) = CONCAT(t1.country_territory_code);
   

Task 4: Add country area data to the country_area column.
Populate the country_area column using data from the Census Bureau International public dataset. .

BigQuery Console Query Editor


UPDATE
   `<dataset_name>.<table_name>` t0
SET
   t0.country_area = t1.country_area
FROM
   `bigquery-public-data.census_bureau_international.country_names_area` t1
WHERE
   t0.country_name = t1.country_name


Task 5: Populate the mobility record data
Populate the mobility column using data from the Google COVID19 public mobility dataset

BigQuery Console Query Editor


 UPDATE
   `<dataset_name>.<table_name>` t0
SET
   t0.mobility.avg_retail      = t1.avg_retail,
   t0.mobility.avg_grocery     = t1.avg_grocery,
   t0.mobility.avg_parks       = t1.avg_parks,
   t0.mobility.avg_transit     = t1.avg_transit,
   t0.mobility.avg_workplace   = t1.avg_workplace,
   t0.mobility.avg_residential = t1.avg_residential
FROM
   ( SELECT country_region, date,
      AVG(retail_and_recreation_percent_change_from_baseline) as avg_retail,
      AVG(grocery_and_pharmacy_percent_change_from_baseline)  as avg_grocery,
      AVG(parks_percent_change_from_baseline) as avg_parks,
      AVG(transit_stations_percent_change_from_baseline) as avg_transit,
      AVG(workplaces_percent_change_from_baseline) as avg_workplace,
      AVG(residential_percent_change_from_baseline)  as avg_residential
      FROM `bigquery-public-data.covid19_google_mobility.mobility_report`
      GROUP BY country_region, date
   ) AS t1
WHERE
   CONCAT(t0.country_name, t0.date) = CONCAT(t1.country_region, t1.date)


Task 6: Query missing data in population & country_area columns
Query the Data Warehouse table to list countries with no population and countries with no country_area defined. Countries that have neither value should appear twice. 

BigQuery Console Query Editor


SELECT DISTINCT country_name
FROM `<dataset_name>.<table_name>`
WHERE population is NULL
UNION ALL
SELECT DISTINCT country_name
FROM `<dataset_name>.<table_name>`
WHERE country_area IS NULL
ORDER BY country_name ASC









