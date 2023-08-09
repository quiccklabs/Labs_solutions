



bq mk austin


bq query --use_legacy_sql=false "
CREATE OR REPLACE MODEL austin.location_model
OPTIONS
  (model_type='linear_reg', labels=['duration_minutes']) AS
SELECT
    start_station_name,
    EXTRACT(HOUR FROM start_time) AS start_hour,
    EXTRACT(DAYOFWEEK FROM start_time) AS day_of_week,
    duration_minutes,
    address AS location
FROM
    \`bigquery-public-data.austin_bikeshare.bikeshare_trips\` AS trips
JOIN
    \`bigquery-public-data.austin_bikeshare.bikeshare_stations\` AS stations
ON
    trips.start_station_name = stations.name
WHERE
    EXTRACT(YEAR FROM start_time) = $TRAINING_YEAR
    AND duration_minutes > 0"



bq query --use_legacy_sql=false "
CREATE OR REPLACE MODEL austin.subscriber_model
OPTIONS
  (model_type='linear_reg', labels=['duration_minutes']) AS
SELECT
    start_station_name,
    EXTRACT(HOUR FROM start_time) AS start_hour,
    subscriber_type,
    duration_minutes
FROM \`bigquery-public-data.austin_bikeshare.bikeshare_trips\` AS trips
WHERE EXTRACT(YEAR FROM start_time) = $TRAINING_YEAR"




bq query --use_legacy_sql=false "
SELECT
  SQRT(mean_squared_error) AS rmse,
  mean_absolute_error
FROM
  ML.EVALUATE(MODEL austin.location_model, (
  SELECT
    start_station_name,
    EXTRACT(HOUR FROM start_time) AS start_hour,
    EXTRACT(DAYOFWEEK FROM start_time) AS day_of_week,
    duration_minutes,
	 address as location
  FROM
    \`bigquery-public-data.austin_bikeshare.bikeshare_trips\` AS trips
  JOIN
   \`bigquery-public-data.austin_bikeshare.bikeshare_stations\` AS stations
  ON
    trips.start_station_name = stations.name
  WHERE EXTRACT(YEAR FROM start_time) = $EVALUATION_YEAR)
)"




bq query --use_legacy_sql=false "
SELECT
  SQRT(mean_squared_error) AS rmse,
  mean_absolute_error
FROM
  ML.EVALUATE(MODEL austin.subscriber_model, (
  SELECT
    start_station_name,
    EXTRACT(HOUR FROM start_time) AS start_hour,
    subscriber_type,
    duration_minutes
  FROM
    \`bigquery-public-data.austin_bikeshare.bikeshare_trips\` AS trips
  WHERE
    EXTRACT(YEAR FROM start_time) = $EVALUATION_YEAR)
)"


bq query --use_legacy_sql=false "
SELECT
  start_station_name,
  COUNT(*) AS trips
FROM
  \`bigquery-public-data.austin_bikeshare.bikeshare_trips\`
WHERE
  EXTRACT(YEAR FROM start_time) = $EVALUATION_YEAR
GROUP BY
  start_station_name
ORDER BY
  trips DESC
"


bq query --use_legacy_sql=false "
SELECT AVG(predicted_duration_minutes) AS average_predicted_trip_length
FROM ML.predict(MODEL austin.subscriber_model, (
SELECT
    start_station_name,
    EXTRACT(HOUR FROM start_time) AS start_hour,
    subscriber_type,
    duration_minutes
FROM
  \`bigquery-public-data.austin_bikeshare.bikeshare_trips\`
WHERE
  EXTRACT(YEAR FROM start_time) = $EVALUATION_YEAR
  AND subscriber_type = 'Single Trip'
  AND start_station_name = '21st & Speedway @PCL'))"







