
#TASK 1

gcloud services enable bigqueryreservation.googleapis.com

bq mk --location=US $TASK_1_DATASET_NAME

gcloud logging sinks create $TASK_1_SINK_NAME\
  bigquery.googleapis.com/projects/$(gcloud config get-value project)/datasets/$TASK_1_DATASET_NAME \
  --log-filter='resource.type="bigquery_resource"'


#TASK 2

bq load \
  --autodetect \
  --source_format=CSV \
  $TASK_1_DATASET_NAME.$TASK_2_TABLE_NAME \
  gs://$(gcloud config get-value project)/cymbal_investments_report.csv


#TASK 3


bq mk --location=US $TASK_3_DATASET_NAME


bq query --use_legacy_sql=false "
CREATE OR REPLACE VIEW $TASK_3_DATASET_NAME.$TASK_3_VIEW_1 AS
SELECT 
  * EXCEPT(TransactTime, TradeReportID, MaturityDate)
FROM \`${TASK_1_DATASET_NAME}.${TASK_2_TABLE_NAME}\`;"


gcloud logging sinks delete $TASK_1_SINK_NAME --quiet

# Colors and styles
BOLD='\033[1m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Project ID (optional: auto-fill)
PROJECT_ID=$(gcloud config get-value project)

# Echo formatted URL
echo -e "${BOLD}${BLUE}👉 Open Log Router in Console:${RESET}"
echo -e "${BLUE}https://console.cloud.google.com/logs/router?inv=1&invt=AbxddQ&project=${PROJECT_ID}${RESET}"

