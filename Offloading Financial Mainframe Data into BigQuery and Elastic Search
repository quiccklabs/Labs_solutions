

export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)

gsutil mb gs://$GOOGLE_CLOUD_PROJECT
gsutil cp -r gs://spls/gsp1153/* gs://$GOOGLE_CLOUD_PROJECT

bq --location=us mk --dataset mainframe_import

gsutil cp gs://$GOOGLE_CLOUD_PROJECT/schema_*.json .

bq load --source_format=NEWLINE_DELIMITED_JSON     mainframe_import.accounts gs://$GOOGLE_CLOUD_PROJECT/accounts.json schema_accounts.json

bq load --source_format=NEWLINE_DELIMITED_JSON     mainframe_import.transactions  gs://$GOOGLE_CLOUD_PROJECT/transactions.json schema_transactions.json

bq query --use_legacy_sql=false \
"CREATE OR REPLACE VIEW \`$GOOGLE_CLOUD_PROJECT.mainframe_import.account_transactions\` AS
SELECT t.*, a.* EXCEPT (id)
FROM \`mainframe_import.accounts\` AS a
JOIN \`mainframe_import.transactions\` AS t
ON a.id = t.account_id"



bq query --use_legacy_sql=false \
"SELECT * FROM \`mainframe_import.transactions\` LIMIT 100"

bq query --use_legacy_sql=false \
"SELECT DISTINCT(occupation), COUNT(occupation)
FROM \`mainframe_import.accounts\`
GROUP BY occupation"

bq query --use_legacy_sql=false \
"SELECT *
FROM \`mainframe_import.accounts\`
WHERE salary_range = '110,000+'
ORDER BY name"

gcloud services enable dataflow.googleapis.com


# enter these values by hand into the cloud shell (one by one). 
export CONNECTION_URL=my-demo:dXMtY2VudHJhbDEuZ2NwLmNsb3VkLmVzLmlvOjQ0MyRlYWFjNTc3ZGI3M2Q0NzdkOGNiM2I3YmIxN2IxNzQwYSRiYzcwN2RiMGU2Y2Q0NmMzYmVlZWM5Y2I3MjNkZGY4Mw==
export API_KEY=NWd6Q2hZa0JYR0ZtRFo4eS0tTmQ6U2F0cm9MRnpUR3FlaF9BY3lsZ0xrQQ==
# to create and run a dataflow job, 
# cut and paste the following 7 lines into the cloud shell.
gcloud dataflow flex-template run bqtoelastic --template-file-gcs-location gs://dataflow-templates-us-central1/latest/flex/BigQuery_to_Elasticsearch --region us-central1 --num-workers 1 --parameters index=transactions,maxNumWorkers=1,query='select * from `YOUR_PROJECT_ID.mainframe_import.account_transactions`',connectionUrl=$CONNECTION_URL,apiKey=$API_KEY

