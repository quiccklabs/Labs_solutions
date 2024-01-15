


bq mk bqml_lab

bq query --use_legacy_sql=false \
"
#standardSQL
CREATE OR REPLACE MODEL \`bqml_lab.sample_model\`
OPTIONS(model_type='logistic_reg') AS
SELECT
  IF(totals.transactions IS NULL, 0, 1) AS label,
  IFNULL(device.operatingSystem, '') AS os,
  device.isMobile AS is_mobile,
  IFNULL(geoNetwork.country, '') AS country,
  IFNULL(totals.pageviews, 0) AS pageviews
FROM
  \`bigquery-public-data.google_analytics_sample.ga_sessions_*\`
WHERE
  _TABLE_SUFFIX BETWEEN '20160801' AND '20170630'
LIMIT 100000;
"



bq query --use_legacy_sql=false \
"
#standardSQL
SELECT
  *
FROM
  ml.EVALUATE(MODEL \`bqml_lab.sample_model\`, (
SELECT
  IF(totals.transactions IS NULL, 0, 1) AS label,
  IFNULL(device.operatingSystem, '') AS os,
  device.isMobile AS is_mobile,
  IFNULL(geoNetwork.country, '') AS country,
  IFNULL(totals.pageviews, 0) AS pageviews
FROM
  \`bigquery-public-data.google_analytics_sample.ga_sessions_*\`
WHERE
  _TABLE_SUFFIX BETWEEN '20170701' AND '20170801'));
"


bq query --use_legacy_sql=false \
"
#standardSQL
SELECT
  country,
  SUM(predicted_label) as total_predicted_purchases
FROM
  ml.PREDICT(MODEL \`bqml_lab.sample_model\`, (
SELECT
  IFNULL(device.operatingSystem, '') AS os,
  device.isMobile AS is_mobile,
  IFNULL(totals.pageviews, 0) AS pageviews,
  IFNULL(geoNetwork.country, '') AS country
FROM
  \`bigquery-public-data.google_analytics_sample.ga_sessions_*\`
WHERE
  _TABLE_SUFFIX BETWEEN '20170701' AND '20170801'))
GROUP BY country
ORDER BY total_predicted_purchases DESC
LIMIT 10;
"


bq query --use_legacy_sql=false \
"
#standardSQL
SELECT
  fullVisitorId,
  SUM(predicted_label) as total_predicted_purchases
FROM
  ml.PREDICT(MODEL \`bqml_lab.sample_model\`, (
SELECT
  IFNULL(device.operatingSystem, '') AS os,
  device.isMobile AS is_mobile,
  IFNULL(totals.pageviews, 0) AS pageviews,
  IFNULL(geoNetwork.country, '') AS country,
  fullVisitorId
FROM
  \`bigquery-public-data.google_analytics_sample.ga_sessions_*\`
WHERE
  _TABLE_SUFFIX BETWEEN '20170701' AND '20170801'))
GROUP BY fullVisitorId
ORDER BY total_predicted_purchases DESC
LIMIT 10;
"