


gcloud auth list

PROJECT_ID=$(gcloud config get-value project)

echo "PROJECT_ID=${PROJECT_ID}"
echo "REGION=${REGION}"

USER=$(gcloud config get-value account 2> /dev/null)
echo "USER=${USER}"

gcloud services enable cloudaicompanion.googleapis.com --project ${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/cloudaicompanion.user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/serviceusage.serviceUsageViewer

#TASK 2

bq mk bqml_tutorial


#TASK 4


bq query --use_legacy_sql=false \
"
SELECT u.id as user_id, u.first_name, u.last_name, avg(oi.sale_price) as avg_sale_price   
FROM \`bigquery-public-data.thelook_ecommerce.users\` as u   
JOIN \`bigquery-public-data.thelook_ecommerce.order_items\` as oi   
ON u.id = oi.user_id   
GROUP BY 1,2,3   
ORDER BY avg_sale_price DESC   
LIMIT 10
"

#TASK 5

bq query --use_legacy_sql=false \
"
# select the sum of sale_price by Date(created_at) and product_id casted to day from bigquery-public-data.thelook_ecommerce.order_id as t1 joined this with products table in the same dataset as t2
SELECT
  SUM(sale_price),
  DATE(created_at) AS created_at_day,
  CAST(product_id as INT64)
FROM
  \`bigquery-public-data.thelook_ecommerce.order_items\` AS t1
JOIN
  \`bigquery-public-data.thelook_ecommerce.products\` AS t2 ON t1.product_id = t2.id
GROUP BY
  created_at_day,
  product_id
"

#TASK 6

bq query --use_legacy_sql=false \
"
CREATE MODEL bqml_tutorial.sales_forecasting_model
OPTIONS(MODEL_TYPE='ARIMA_PLUS',
time_series_timestamp_col='date_col',
time_series_data_col='total_sales',
time_series_id_col='product_id') AS
SELECT sum(sale_price) as total_sales,
DATE(created_at) as date_col,
product_id
FROM \`bigquery-public-data.thelook_ecommerce.order_items\`
AS t1
INNER JOIN \`bigquery-public-data.thelook_ecommerce.products\`
AS t2
ON t1.product_id = t2.id
GROUP BY 2, 3;
"



bq query --use_legacy_sql=false "
SELECT
  *
FROM
  ML.FORECAST(MODEL \`$DEVSHELL_PROJECT_ID.bqml_tutorial.sales_forecasting_model\`,
    STRUCT(
      7 AS horizon,
      0.95 AS confidence_level
    )
  )
"


