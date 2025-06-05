
#!/bin/bash

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)



gsutil cp gs://spls/gsp774/archive.zip .

unzip archive.zip

export DATA_FILE=PS_20174392719_1491204439457_log.csv

bq mk --dataset $PROJECT_ID:finance

gsutil mb gs://$PROJECT_ID

gsutil cp $DATA_FILE gs://$PROJECT_ID

bq load --autodetect --source_format=CSV --max_bad_records=100000 finance.fraud_data gs://$PROJECT_ID/$DATA_FILE


bq query --use_legacy_sql=false \
'
SELECT type, isFraud, count(*) as cnt
FROM `finance.fraud_data`
GROUP BY isFraud, type
ORDER BY type
'

bq query --use_legacy_sql=false \
'
SELECT isFraud, count(*) as cnt
FROM `finance.fraud_data`
WHERE type in ("CASH_OUT", "TRANSFER")
GROUP BY isFraud
'

bq query --use_legacy_sql=false \
'
SELECT *
FROM `finance.fraud_data`
ORDER BY amount desc
LIMIT 10
'


#TASK 5

bq query --use_legacy_sql=false \
'
CREATE OR REPLACE TABLE finance.fraud_data_sample AS
SELECT
      type,
      amount,
      nameOrig,
      nameDest,
      oldbalanceOrg as oldbalanceOrig,  #standardize the naming.
      newbalanceOrig,
      oldbalanceDest,
      newbalanceDest,
# add new features:
      if(oldbalanceOrg = 0.0, 1, 0) as origzeroFlag,
      if(newbalanceDest = 0.0, 1, 0) as destzeroFlag,
      round((newbalanceDest-oldbalanceDest-amount)) as amountError,
      generate_uuid() as id,        #create a unique id for each transaction.
      isFraud
FROM finance.fraud_data
WHERE
# filter unnecessary transaction types:
      type in("CASH_OUT","TRANSFER") AND
# undersample:
      (isFraud = 1 or (RAND()< 10/100))  # select 10% of the non-fraud cases
'

bq query --use_legacy_sql=false \
'
CREATE OR REPLACE TABLE finance.fraud_data_test AS
SELECT *
FROM finance.fraud_data_sample
where RAND() < 20/100
'



bq query --use_legacy_sql=false \
'
CREATE OR REPLACE TABLE finance.fraud_data_model AS
SELECT
*
FROM finance.fraud_data_sample  
EXCEPT distinct select * from finance.fraud_data_test  
'


#TASK 6

bq query --use_legacy_sql=false \
"CREATE OR REPLACE MODEL
  finance.model_unsupervised OPTIONS(model_type='kmeans', num_clusters=5) AS
SELECT
  amount, oldbalanceOrig, newbalanceOrig, oldbalanceDest, newbalanceDest, type, origzeroFlag, destzeroFlag, amountError
  FROM
  \`finance.fraud_data_model\`"


bq query --use_legacy_sql=false \
'SELECT
  centroid_id, sum(isfraud) as fraud_cnt,  count(*) total_cnt
FROM
  ML.PREDICT(MODEL `finance.model_unsupervised`,
    (
    SELECT *
    FROM  `finance.fraud_data_test`))
group by centroid_id
order by centroid_id'


bq query --use_legacy_sql=false \
"CREATE OR REPLACE MODEL
  finance.model_supervised_initial
  OPTIONS(model_type='LOGISTIC_REG', INPUT_LABEL_COLS = ['isfraud']
  )
AS
SELECT
type, amount, oldbalanceOrig, newbalanceOrig, oldbalanceDest, newbalanceDest, isFraud
FROM finance.fraud_data_model"


bq query --use_legacy_sql=false \
'SELECT
  *
FROM
  ML.WEIGHTS(MODEL `finance.model_supervised_initial`,
    STRUCT(true AS standardize))'


bq query --use_legacy_sql=false \
'SELECT id, label as predicted, isFraud as actual
FROM
  ML.PREDICT(MODEL `finance.model_supervised_initial`,
   (
    SELECT  *
    FROM  `finance.fraud_data_test`
   )
  ), unnest(predicted_isfraud_probs) as p
where p.label = 1 and p.prob > 0.5'
