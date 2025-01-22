

echo ""
echo ""

read -p "ENTER REGION: " REGION

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
export CONNECTION_URL=178e132f87fc4591a7b39df9cdd73ccf:dXMtY2VudHJhbDEuZ2NwLmNsb3VkLmVzLmlvJGU1YTdlM2M5ODk2ZjQ5Zjg4ODYxOTlmYjZmMjBlNGE3JDE1MjYyY2VkZWM4NTRmY2ViZjliYjI4OTFhZDE1MWY1
export API_KEY=QjBIMWpwUUI1dlpPRHNXSlBnUGc6MWUxTnktSnNRei1wSUhuZi1CWmY0dw==
# to create and run a dataflow job, 
# cut and paste the following 7 lines into the cloud shell.
sleep 30
gcloud dataflow flex-template run bqtoelastic-`date +%s` --worker-machine-type=e2-standard-2 --template-file-gcs-location gs://dataflow-templates-$REGION/latest/flex/BigQuery_to_Elasticsearch --region $REGION --num-workers 1 --parameters index=transactions,maxNumWorkers=1,query="select * from \`$GOOGLE_CLOUD_PROJECT\`.mainframe_import.account_transactions",connectionUrl=$CONNECTION_URL,apiKey=$API_KEY



# Bold and blue URL
echo -e "\033[1;34mhttps://console.cloud.google.com/dataflow/jobs?referrer=search&project=\033[0m"
