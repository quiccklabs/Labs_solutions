


bq mk ecommerce

bq query --use_legacy_sql=false \
"
#standardSQL
SELECT DISTINCT
  fullVisitorId,
  date,
  city,
  pageTitle
FROM \`data-to-insights.ecommerce.all_sessions_raw\`
WHERE date = '20170708'
LIMIT 5
"


bq query --use_legacy_sql=false \
"
#standardSQL
SELECT DISTINCT
  fullVisitorId,
  date,
  city,
  pageTitle
FROM \`data-to-insights.ecommerce.all_sessions_raw\`
WHERE date = '20180708'
LIMIT 5
"

bq query --use_legacy_sql=false \
"
#standardSQL
 CREATE OR REPLACE TABLE ecommerce.partition_by_day
 PARTITION BY date_formatted
 OPTIONS(
   description='a table partitioned by date'
 ) AS

 SELECT DISTINCT
 PARSE_DATE('%Y%m%d', date) AS date_formatted,
 fullvisitorId
 FROM \`data-to-insights.ecommerce.all_sessions_raw\`
"




bq query --use_legacy_sql=false \
"
#standardSQL
SELECT *
FROM \`data-to-insights.ecommerce.partition_by_day\`
WHERE date_formatted = '2016-08-01'
"



bq query --use_legacy_sql=false \
"
#standardSQL
SELECT *
FROM \`data-to-insights.ecommerce.partition_by_day\`
WHERE date_formatted = '2018-07-08'
"



bq query --use_legacy_sql=false \
"
#standardSQL
SELECT
  DATE(CAST(year AS INT64), CAST(mo AS INT64), CAST(da AS INT64)) AS date,
  (SELECT ANY_VALUE(name) FROM \`bigquery-public-data.noaa_gsod.stations\` AS stations
   WHERE stations.usaf = stn) AS station_name,  -- Stations may have multiple names
  prcp
FROM \`bigquery-public-data.noaa_gsod.gsod*\` AS weather
WHERE prcp < 99.9  -- Filter unknown values
  AND prcp > 0      -- Filter stations/days with no precipitation
  AND _TABLE_SUFFIX >= '2018'
ORDER BY date DESC -- Where has it rained/snowed recently
LIMIT 10
"


bq query --use_legacy_sql=false \
"
#standardSQL
 CREATE OR REPLACE TABLE ecommerce.days_with_rain
 PARTITION BY date
 OPTIONS (
   partition_expiration_days=60,
   description='weather stations with precipitation, partitioned by day'
 ) AS


 SELECT
   DATE(CAST(year AS INT64), CAST(mo AS INT64), CAST(da AS INT64)) AS date,
   (SELECT ANY_VALUE(name) FROM \`bigquery-public-data.noaa_gsod.stations\` AS stations
    WHERE stations.usaf = stn) AS station_name,  -- Stations may have multiple names
   prcp
 FROM \`bigquery-public-data.noaa_gsod.gsod*\` AS weather
 WHERE prcp < 99.9  -- Filter unknown values
   AND prcp > 0      -- Filter
   AND _TABLE_SUFFIX >= '2018'
"



