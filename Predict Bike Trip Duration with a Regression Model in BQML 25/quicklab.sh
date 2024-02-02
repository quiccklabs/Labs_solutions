
# Set the Dataset ID to mydataset
export DATASET_ID=bike_model

# Set the Data location to eu (multiple regions in the European Union)
export DATA_LOCATION=EU

# Create the dataset
bq --location=$DATA_LOCATION mk $DATASET_ID


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE MODEL
  bike_model.model
OPTIONS
  (input_label_cols=['duration'],
    model_type='linear_reg') AS
SELECT
  duration,
  start_station_name,
  CAST(EXTRACT(dayofweek
    FROM
      start_date) AS STRING) AS dayofweek,
  CAST(EXTRACT(hour
    FROM
      start_date) AS STRING) AS hourofday
FROM
  \`bigquery-public-data\`.london_bicycles.cycle_hire
  WHERE \`duration\` IS NOT NULL
"

sleep 20

bq query --use_legacy_sql=false \
"
SELECT * FROM ML.EVALUATE(MODEL \`bike_model.model\`)
"


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE MODEL
  bike_model.model_weekday
OPTIONS
  (input_label_cols=['duration'],
    model_type='linear_reg') AS
SELECT
  duration,
  start_station_name,
IF
  (EXTRACT(dayofweek
    FROM
      start_date) BETWEEN 2 AND 6,
    'weekday',
    'weekend') AS dayofweek,
  CAST(EXTRACT(hour
    FROM
      start_date) AS STRING) AS hourofday
FROM
  \`bigquery-public-data\`.london_bicycles.cycle_hire
  WHERE \`duration\` IS NOT NULL
"

sleep 20

bq query --use_legacy_sql=false \
"
SELECT * FROM ML.EVALUATE(MODEL \`bike_model.model_weekday\`)
"


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE MODEL
  bike_model.model_bucketized
OPTIONS
  (input_label_cols=['duration'],
    model_type='linear_reg') AS
SELECT
  duration,
  start_station_name,
IF
  (EXTRACT(dayofweek
    FROM
      start_date) BETWEEN 2 AND 6,
    'weekday',
    'weekend') AS dayofweek,
  ML.BUCKETIZE(EXTRACT(hour
    FROM
      start_date),
    [5, 10, 17]) AS hourofday
FROM
  \`bigquery-public-data\`.london_bicycles.cycle_hire
  WHERE \`duration\` IS NOT NULL
"

sleep 20


bq query --use_legacy_sql=false \
"
SELECT * FROM ML.EVALUATE(MODEL \`bike_model.model_bucketized\`)
"


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE MODEL
  bike_model.model_bucketized TRANSFORM(* EXCEPT(start_date),
  IF
    (EXTRACT(dayofweek
      FROM
        start_date) BETWEEN 2 AND 6,
      'weekday',
      'weekend') AS dayofweek,
    ML.BUCKETIZE(EXTRACT(HOUR
      FROM
        start_date),
      [5, 10, 17]) AS hourofday )
OPTIONS
  (input_label_cols=['duration'],
    model_type='linear_reg') AS
SELECT
  duration,
  start_station_name,
  start_date
FROM
  \`bigquery-public-data\`.london_bicycles.cycle_hire
  WHERE \`duration\` IS NOT NULL
"


bq query --use_legacy_sql=false \
"
SELECT
  *
FROM
  ML.PREDICT(MODEL bike_model.model_bucketized,
    (
    SELECT
      'Park Lane , Hyde Park' AS start_station_name,
      CURRENT_TIMESTAMP() AS start_date) )
"

bq query --use_legacy_sql=false \
"
SELECT
  *
FROM
  ML.PREDICT(MODEL bike_model.model_bucketized,
    (
    SELECT
      start_station_name,
      start_date
    FROM
      \`bigquery-public-data\`.london_bicycles.cycle_hire
    LIMIT
      100) )
"


bq query --use_legacy_sql=false \
"
SELECT * FROM ML.WEIGHTS(MODEL bike_model.model_bucketized)
"


