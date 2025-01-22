
echo ""
read -p "ENTER ZONE 1 :- " ZONE

echo ""
echo "ZONE 2 must be different from ZONE 1"
read -p "ENTER ZONE 2 :- " ZONE_2



export REGION="${ZONE%-*}"

gcloud services disable dataflow.googleapis.com


gcloud services enable dataflow.googleapis.com


gcloud bigtable instances create ecommerce-recommendations \
  --display-name=ecommerce-recommendations \
  --cluster-storage-type=SSD \
  --cluster-config="id=ecommerce-recommendations-c1,zone=$ZONE"


gcloud bigtable clusters update ecommerce-recommendations-c1 \
    --instance=ecommerce-recommendations \
    --autoscaling-max-nodes=5 \
    --autoscaling-min-nodes=1 \
    --autoscaling-cpu-target=60 


gsutil mb gs://$DEVSHELL_PROJECT_ID

gcloud bigtable instances tables create SessionHistory \
    --instance=ecommerce-recommendations \
    --project=$DEVSHELL_PROJECT_ID \
    --column-families=Engagements,Sales


gcloud bigtable instances tables create PersonalizedProducts \
    --instance=ecommerce-recommendations \
    --project=$DEVSHELL_PROJECT_ID \
    --column-families=Recommendations




gcloud dataflow jobs run import-sessions --gcs-location gs://dataflow-templates-$REGION/latest/GCS_SequenceFile_to_Cloud_Bigtable --region $REGION --staging-location gs://$DEVSHELL_PROJECT_ID/temp --parameters bigtableProject=$DEVSHELL_PROJECT_ID,bigtableInstanceId=ecommerce-recommendations,bigtableTableId=SessionHistory,sourcePattern=gs://cloud-training/OCBL377/retail-engagements-sales-00000-of-00001,mutationThrottleLatencyMs=0


gcloud dataflow jobs run import-recommendations --gcs-location gs://dataflow-templates-$REGION/latest/GCS_SequenceFile_to_Cloud_Bigtable --region $REGION --staging-location gs://$DEVSHELL_PROJECT_ID/temp --parameters bigtableProject=$DEVSHELL_PROJECT_ID,bigtableInstanceId=ecommerce-recommendations,bigtableTableId=PersonalizedProducts,sourcePattern=gs://cloud-training/OCBL377/retail-recommendations-00000-of-00001



gcloud bigtable clusters create ecommerce-recommendations-c2 \
    --instance=ecommerce-recommendations \
    --zone=$ZONE_2


gcloud bigtable clusters update ecommerce-recommendations-c2 \
    --instance=ecommerce-recommendations \
    --autoscaling-max-nodes=5 \
    --autoscaling-min-nodes=1 \
    --autoscaling-cpu-target=60 



gcloud bigtable backups create PersonalizedProducts_7 --instance=ecommerce-recommendations \
  --cluster=ecommerce-recommendations-c1 \
  --table=PersonalizedProducts \
  --retention-period=7d 


gcloud bigtable instances tables restore \
--source=projects/$DEVSHELL_PROJECT_ID/instances/ecommerce-recommendations/clusters/ecommerce-recommendations-c1/backups/PersonalizedProducts_7 \
--async \
--destination=PersonalizedProducts_7_restored \
--destination-instance=ecommerce-recommendations \
--project=$DEVSHELL_PROJECT_ID


sleep 100

gcloud dataflow jobs run import-sessions --gcs-location gs://dataflow-templates-$REGION/latest/GCS_SequenceFile_to_Cloud_Bigtable --region $REGION --staging-location gs://$DEVSHELL_PROJECT_ID/temp --parameters bigtableProject=$DEVSHELL_PROJECT_ID,bigtableInstanceId=ecommerce-recommendations,bigtableTableId=SessionHistory,sourcePattern=gs://cloud-training/OCBL377/retail-engagements-sales-00000-of-00001,mutationThrottleLatencyMs=0


gcloud dataflow jobs run import-recommendations --gcs-location gs://dataflow-templates-$REGION/latest/GCS_SequenceFile_to_Cloud_Bigtable --region $REGION --staging-location gs://$DEVSHELL_PROJECT_ID/temp --parameters bigtableProject=$DEVSHELL_PROJECT_ID,bigtableInstanceId=ecommerce-recommendations,bigtableTableId=PersonalizedProducts,sourcePattern=gs://cloud-training/OCBL377/retail-recommendations-00000-of-00001

# Bold and blue URL
echo -e "\033[1;34mhttps://console.cloud.google.com/dataflow/jobs?referrer=search&project=\033[0m"






