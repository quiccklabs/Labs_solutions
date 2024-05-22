#GSP1054






export REGION="${ZONE%-*}"

gcloud auth list

gcloud services disable dataflow.googleapis.com
gcloud services enable dataflow.googleapis.com



gsutil mb gs://$DEVSHELL_PROJECT_ID


  gcloud bigtable instances tables create UserSessions \
  --instance=personalized-sales \
  --project=$DEVSHELL_PROJECT_ID \
  --column-families=Interactions,Sales

sleep 100

gcloud dataflow jobs run import-usersessions --gcs-location gs://dataflow-templates-$REGION/latest/GCS_SequenceFile_to_Cloud_Bigtable --region $REGION --staging-location gs://$DEVSHELL_PROJECT_ID/temp --parameters bigtableProject=$DEVSHELL_PROJECT_ID,bigtableInstanceId=personalized-sales,bigtableTableId=UserSessions,sourcePattern=gs://cloud-training/OCBL377/retail-interactions-sales-00000-of-00001,mutationThrottleLatencyMs=0



echo -e "\e[1m\e[33mClick here: https://console.cloud.google.com/dataflow/jobs?project=$DEVSHELL_PROJECT_ID&walkthrough_id=dataflow_index\e[0m"


