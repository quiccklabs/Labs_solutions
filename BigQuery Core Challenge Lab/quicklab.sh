
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

echo "http://console.cloud.google.com/logs/router?inv=1&invt=AbxddQ&project="


