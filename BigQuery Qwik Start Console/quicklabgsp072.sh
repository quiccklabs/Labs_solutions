


bq query --use_legacy_sql=false \
'
#standardSQL
SELECT
 weight_pounds, state, year, gestation_weeks
FROM
 `bigquery-public-data.samples.natality`
ORDER BY weight_pounds DESC LIMIT 10;
'

bq mk babynames

https://labshell-service-mvrcyiow4a-uc.a.run.app

gsutil cp gs://spls/gsp072/baby-names.zip .

unzip baby-names.zip

bq load --autodetect --source_format=CSV babynames.names_2014 gs://spls/gsp072/baby-names/yob2014.txt name:string,gender:string,count:integer


bq query --use_legacy_sql=false \
'
#standardSQL
SELECT
 name, count
FROM
 `babynames.names_2014`
WHERE
 gender = "M"
ORDER BY count DESC LIMIT 5;
'
