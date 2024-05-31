

bq query \
--use_legacy_sql=false \
'LOAD DATA OVERWRITE fintech.state_region
(
  state string,
  subregion string,
  region string
)
FROM FILES (
  format = "CSV",
  uris = ["gs://sureskills-lab-dev/future-workforce/da-capstone/temp_35_us/state_region_mapping/state_region_*.csv"]
);'



bq query --use_legacy_sql=false \
'CREATE OR REPLACE TABLE fintech.loan_with_region AS
SELECT
  lo.loan_id,
  lo.loan_amount,
  sr.region
FROM
  fintech.loan lo
INNER JOIN
  fintech.state_region sr
ON
  lo.state = sr.state;'


bq query --use_legacy_sql=false \
'SELECT loan_id, application.purpose FROM fintech.loan;'



bq query --use_legacy_sql=false \
'CREATE TABLE fintech.loan_purposes AS
SELECT DISTINCT application.purpose
FROM fintech.loan;'


bq query --use_legacy_sql=false \
'SELECT 
  EXTRACT(YEAR FROM PARSE_DATE("%B %Y", issue_date)) AS issue_year,
  loan_amount
FROM 
  fintech.loan
ORDER BY 
  issue_year, issue_date;'

bq query --use_legacy_sql=false \
'CREATE TABLE fintech.loan_count_by_year AS
SELECT issue_year, count(loan_id) AS loan_count
FROM fintech.loan
GROUP BY issue_year;'



echo -e "\e[1;34mhttps://console.cloud.google.com/bigquery?referrer=search&project=$DEVSHELL_PROJECT_ID\e[0m"
