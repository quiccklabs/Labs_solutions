
echo ""
echo ""

read -p "ENTER REGION: " REGION


export GCP_PROJECT_ID=$(gcloud config list core/project --format="value(core.project)")

gcloud storage buckets create gs://${GCP_PROJECT_ID}-cymbal-bq-opt-big-lake --project=${GCP_PROJECT_ID} --default-storage-class=COLDLINE --location=$REGION --uniform-bucket-level-access

bq query --use_legacy_sql=false \
"
EXPORT DATA
 OPTIONS (
   uri = 'gs://$GCP_PROJECT_ID-cymbal-bq-opt-big-lake/top_products_20220801*',
   format = 'CSV',
   overwrite = true,
   header = true,
   field_delimiter = ';')
AS (
SELECT
  product_name,
  volume_of_product_purchased
FROM
  \`cymbal_bq_opt_3.top_products_20220801_bigquerystorage\`
);
"

export GCP_PROJECT_ID=$(gcloud config list core/project --format="value(core.project)")

export GCP_PROJECT_NUM=$(gcloud projects describe $GCP_PROJECT_ID --format="value(projectNumber)")

gcloud services enable bigqueryconnection.googleapis.com

#connection

bq mk \
  --connection \
  --location=$REGION \
  --project_id=${GCP_PROJECT_ID} \
  --connection_type=CLOUD_RESOURCE \
  mybiglakegcsconnector

bq show --connection ${GCP_PROJECT_NUM}.$REGION.mybiglakegcsconnector

bq show --connection ${GCP_PROJECT_NUM}.$REGION.mybiglakegcsconnector
export CONNECTION_SA=$(bq show --format=json --connection ${GCP_PROJECT_NUM}.$REGION.mybiglakegcsconnector  | jq ".cloudResource" | jq ".serviceAccountId" |tr -d '"')

gsutil iam ch serviceAccount:${CONNECTION_SA}:objectViewer gs://${GCP_PROJECT_ID}-cymbal-bq-opt-big-lake


bq query --use_legacy_sql=false \
"
CREATE EXTERNAL TABLE
\`cymbal_bq_opt_3.top_products_20220801_biglake\`
WITH CONNECTION \`$GCP_PROJECT_ID.$REGION.mybiglakegcsconnector\`
OPTIONS (
  format='CSV',
  field_delimiter=';',
  uris=['gs://$GCP_PROJECT_ID-cymbal-bq-opt-big-lake/top_products_20220801*']
);
"



bq query --use_legacy_sql=false \
'
CREATE TABLE
 cymbal_bq_opt_3.orders_with_timestamps_bigquerystorage
PARTITION BY
 orderdate
OPTIONS ( require_partition_filter = TRUE) AS
SELECT
 DATE(order_ts) AS orderdate,
 *
FROM
 `cymbal_bq_opt_1.orders_with_timestamps`;
'

bq query --use_legacy_sql=false \
'
SELECT
orderdate,
COUNT(*) as record_count
FROM
`cymbal_bq_opt_3.orders_with_timestamps_bigquerystorage`
WHERE
orderdate IN ("2022-08-01","2022-08-02", "2022-08-03", "2022-08-04")
GROUP BY
orderdate;
'

bq query --use_legacy_sql=false \
'
SELECT
 table_name,
 partition_id,
 total_rows
FROM
 `cymbal_bq_opt_3.INFORMATION_SCHEMA.PARTITIONS`
WHERE
 partition_id IS NOT NULL
 AND table_name = "orders_with_timestamps_bigquerystorage"
ORDER BY
 partition_id ASC;
'


bq query --use_legacy_sql=false \
"
EXPORT DATA
OPTIONS ( uri = 'gs://$GCP_PROJECT_ID-cymbal-bq-opt-big-lake/orders/orderdate=2022-08-01/*',
 format = 'CSV',
 overwrite = TRUE,
 header = TRUE,
 field_delimiter = ';') AS (
SELECT
 * EXCEPT (orderdate)
FROM
 \`cymbal_bq_opt_3.orders_with_timestamps_bigquerystorage\`
WHERE
 orderdate = '2022-08-01' );
"


bq query --use_legacy_sql=false \
"
EXPORT DATA
OPTIONS ( uri = 'gs://$GCP_PROJECT_ID-cymbal-bq-opt-big-lake/orders/orderdate=2022-08-02/*',
 format = 'CSV',
 overwrite = TRUE,
 header = TRUE,
 field_delimiter = ';') AS (
SELECT
 * EXCEPT (orderdate)
FROM
 \`cymbal_bq_opt_3.orders_with_timestamps_bigquerystorage\`
WHERE
 orderdate = '2022-08-02' );
"


echo "y" | bq rm --table ${GCP_PROJECT_ID}:cymbal_bq_opt_3.orders_with_timestamps_bigquerystorage\$20220801

echo "y" | bq rm --table ${GCP_PROJECT_ID}:cymbal_bq_opt_3.orders_with_timestamps_bigquerystorage\$20220802



bq query --use_legacy_sql=false \
"
CREATE EXTERNAL TABLE
 \`cymbal_bq_opt_3.orders_with_timestamps_biglake\`
WITH PARTITION COLUMNS (orderdate DATE)
WITH CONNECTION \`$GCP_PROJECT_ID.$REGION.mybiglakegcsconnector\` OPTIONS (
   format ='CSV',
   field_delimiter = ';',
   uris = ['gs://$GCP_PROJECT_ID-cymbal-bq-opt-big-lake/orders*'],
   hive_partition_uri_prefix = 'gs://$GCP_PROJECT_ID-cymbal-bq-opt-big-lake/orders',
   require_hive_partition_filter = TRUE );
"

bq query --use_legacy_sql=false \
'
CREATE OR REPLACE VIEW
 `cymbal_bq_opt_3.orders_by_day` AS (
 SELECT
   orderdate,
   order_ts,
   days_since_prior_order,
   order_dow,
   order_hour_of_day,
   order_id,
   order_number,
   user_id
 FROM (
   SELECT
     orderdate,
     order_ts,
     days_since_prior_order,
     order_dow,
     order_hour_of_day,
     order_id,
     order_number,
     user_id
   FROM
     `cymbal_bq_opt_3.orders_with_timestamps_bigquerystorage` )
 UNION ALL (
   SELECT
     orderdate,
     order_ts,
     days_since_prior_order,
     order_dow,
     order_hour_of_day,
     order_id,
     order_number,
     user_id
   FROM
     `cymbal_bq_opt_3.orders_with_timestamps_biglake` ) );

'


bq query --use_legacy_sql=false \
'
SELECT
orderdate,
COUNT(*) as record_count
FROM
`cymbal_bq_opt_3.orders_by_day`
WHERE
orderdate IN ("2022-08-01","2022-08-02", "2022-08-03", "2022-08-04")
GROUP BY
orderdate;
'
