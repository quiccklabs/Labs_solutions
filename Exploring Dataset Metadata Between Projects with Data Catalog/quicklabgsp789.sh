

echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter PROJECT_ID_1: " PROJECT_ID_1
read -p "Enter PROJECT_ID_2: " PROJECT_ID_2
read -p "Enter REGION: " REGION


bq query --use_legacy_sql=false --project_id=$PROJECT_ID_2 \
"
SELECT
  contributing_factor_vehicle_1 AS collision_factor,
  COUNT(*) AS num_collisions
FROM
  \`new_york_mv_collisions.nypd_mv_collisions\`
WHERE
  contributing_factor_vehicle_1 != 'Unspecified'
  AND contributing_factor_vehicle_1 != ''
GROUP BY
  collision_factor
ORDER BY
  num_collisions DESC
LIMIT 10;
"

bq query --use_legacy_sql=false --project_id=$PROJECT_ID_1 \
"
WITH unknown AS (
  SELECT
    gender,
    CONCAT(start_station_name, ' to ', end_station_name) AS route,
    COUNT(*) AS num_trips
  FROM
    \`new_york_citibike.citibike_trips\`
  WHERE gender = 'unknown'
  GROUP BY
    gender,
    start_station_name,
    end_station_name
  ORDER BY
    num_trips DESC
  LIMIT 5
)

, female AS (
  SELECT
    gender,
    CONCAT(start_station_name, ' to ', end_station_name) AS route,
    COUNT(*) AS num_trips
  FROM
    \`new_york_citibike.citibike_trips\`
  WHERE gender = 'female'
  GROUP BY
    gender,
    start_station_name,
    end_station_name
  ORDER BY
    num_trips DESC
  LIMIT 5
)

, male AS (
  SELECT
    gender,
    CONCAT(start_station_name, ' to ', end_station_name) AS route,
    COUNT(*) AS num_trips
  FROM
    \`bigquery-public-data.new_york_citibike.citibike_trips\`
  WHERE gender = 'male'
  GROUP BY
    gender,
    start_station_name,
    end_station_name
  ORDER BY
    num_trips DESC
  LIMIT 5
)

SELECT * FROM unknown
UNION ALL
SELECT * FROM female
UNION ALL
SELECT * FROM male;
"




gcloud data-catalog tag-templates create new_york_datasets --display-name="New York Datasets" --project=$PROJECT_ID_1 --location=$REGION --field=id=contains_pii,display-name="Contains PII",type='enum(None|Birth date|Gender|Geo location)' --field=id=data_owner_team,display-name="Data Owner Team",type='enum(Marketing|Data Science|Sales|Engineering)',required=TRUE
