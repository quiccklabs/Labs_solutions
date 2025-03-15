
bq query --use_legacy_sql=false \
"SELECT
  *
FROM
  \`bigquery-public-data.new_york_citibike.citibike_stations\`
LIMIT
  10"



bq query --use_legacy_sql=false \
"SELECT
  ST_GeogPoint(longitude, latitude) AS WKT,
  num_bikes_available
FROM
  \`bigquery-public-data.new_york_citibike.citibike_stations\`
WHERE num_bikes_available > 30"
