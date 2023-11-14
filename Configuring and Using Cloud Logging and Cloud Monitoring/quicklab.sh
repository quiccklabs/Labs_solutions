






git clone --depth 1 https://github.com/quiccklabs/Redacting-Sensitive-Data-with-Cloud-Data-Loss-Prevention.git --branch main --single-branch stackdriver-lab

mv ~/stackdriver-lab/stackdriver-lab/* ~/stackdriver-lab/

cd stackdriver-lab

sudo chmod +x setup.sh
./setup.sh

sudo chmod +x gke.sh
./gke.sh

sudo chmod +x pubsub.sh
./pubsub.sh


bq mk project_logs
slepp 15
export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="json(projectNumber)" --quiet | jq -r '.projectNumber')

# Export the service account to a variable
SERVICE_ACCOUNT=service-$PROJECT_NUMBER@gcp-sa-logging.iam.gserviceaccount.com

# Grant the roles/bigquery.dataEditor role to the service account
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=serviceAccount:$SERVICE_ACCOUNT \
  --role=roles/bigquery.dataEditor

# Export the table ID to a variable
TABLE_ID=$(bq ls --project_id $DEVSHELL_PROJECT_ID --dataset_id project_logs --format=json | jq -r '.[0].tableReference.tableId')


bq query --use_legacy_sql=false \
"
SELECT
  logName, resource.type, resource.labels.zone, resource.labels.project_id,
FROM
  \`$DEVSHELL_PROJECT_ID.project_logs.$TABLE_ID\`
"

gcloud alpha logging sinks create vm_logs bigquery.googleapis.com/projects/$DEVSHELL_PROJECT_ID/datasets/project_logs --log-filter='resource.type="gce_instance"'

gcloud alpha logging sinks create load_bal_logs bigquery.googleapis.com/projects/$DEVSHELL_PROJECT_ID/datasets/project_logs --log-filter='resource.type="http_load_balancer"'


gcloud logging read "resource.type=gce_instance AND logName=projects/$DEVSHELL_PROJECT_ID/logs/syslog AND textPayload:SyncAddress" --limit 10 --format json

sleep 15

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="json(projectNumber)" --quiet | jq -r '.projectNumber')

# Export the service account to a variable
SERVICE_ACCOUNT=service-$PROJECT_NUMBER@gcp-sa-logging.iam.gserviceaccount.com

# Grant the roles/bigquery.dataEditor role to the service account
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=serviceAccount:$SERVICE_ACCOUNT \
  --role=roles/bigquery.dataEditor

# Export the table ID to a variable
TABLE_ID=$(bq ls --project_id $DEVSHELL_PROJECT_ID --dataset_id project_logs --format=json | jq -r '.[0].tableReference.tableId')


bq query --use_legacy_sql=false \
"
SELECT
  logName, resource.type, resource.labels.zone, resource.labels.project_id,
FROM
  \`$DEVSHELL_PROJECT_ID.project_logs.$TABLE_ID\`
"


gcloud logging metrics create 403s \
    --project=$DEVSHELL_PROJECT_ID \
    --description="Subscribe to quicklab" \
    --log-filter='resource.type="gce_instance" AND log_name="projects/'$DEVSHELL_PROJECT_ID'/logs/syslog"'

sleep 15

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="json(projectNumber)" --quiet | jq -r '.projectNumber')

# Export the service account to a variable
SERVICE_ACCOUNT=service-$PROJECT_NUMBER@gcp-sa-logging.iam.gserviceaccount.com

# Grant the roles/bigquery.dataEditor role to the service account
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=serviceAccount:$SERVICE_ACCOUNT \
  --role=roles/bigquery.dataEditor

# Export the table ID to a variable
TABLE_ID=$(bq ls --project_id $DEVSHELL_PROJECT_ID --dataset_id project_logs --format=json | jq -r '.[0].tableReference.tableId')


bq query --use_legacy_sql=false \
"
SELECT
  logName, resource.type, resource.labels.zone, resource.labels.project_id,
FROM
  \`$DEVSHELL_PROJECT_ID.project_logs.$TABLE_ID\`
"
