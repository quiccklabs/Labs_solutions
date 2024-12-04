
bq mk nyctaxi

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/refs/heads/master/Loading%20Your%20Own%20Data%20into%20BigQuery/nyc_tlc_yellow_trips_2018_subset_1.csv

bq load \
  --source_format=CSV \
  --autodetect \
  nyctaxi.2018trips \
  nyc_tlc_yellow_trips_2018_subset_1.csv

bq query --use_legacy_sql=false "SELECT COUNT(*) AS row_count FROM nyctaxi.2018trips"


bq load \
--source_format=CSV \
--autodetect \
--noreplace  \
nyctaxi.2018trips \
gs://cloud-training/OCBL013/nyc_tlc_yellow_trips_2018_subset_2.csv



bq query --use_legacy_sql=false \
"CREATE TABLE nyctaxi.january_trips AS
SELECT
  *
FROM
  nyctaxi.2018trips
WHERE
  EXTRACT(Month FROM pickup_datetime) = 1;"


bq query --use_legacy_sql=false \
"SELECT
  *
FROM
  nyctaxi.january_trips
ORDER BY
  trip_distance DESC
LIMIT
  1"

