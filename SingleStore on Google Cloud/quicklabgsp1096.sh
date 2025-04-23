


export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")


PROJECT_ID=`gcloud config get-value project`

export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")



gcloud storage buckets create gs://$GOOGLE_CLOUD_PROJECT --location=$REGION

gcloud storage cp -r gs://configuring-singlestore-on-gcp/drivers gs://$GOOGLE_CLOUD_PROJECT

gcloud storage cp -r gs://configuring-singlestore-on-gcp/trips gs://$GOOGLE_CLOUD_PROJECT

gcloud storage cp gs://configuring-singlestore-on-gcp/neighborhoods.csv gs://$GOOGLE_CLOUD_PROJECT

sleep 20
gcloud dataflow jobs run GCStoPS --gcs-location gs://dataflow-templates-$REGION/latest/Stream_GCS_Text_to_Cloud_PubSub --region $REGION --max-workers 5 --num-workers 2 --worker-machine-type e2-standard-2 --staging-location gs://$GOOGLE_CLOUD_PROJECT-dataflow/temp/dataflow-temp.txt --additional-experiments streaming_mode_exactly_once --parameters inputFilePattern=gs://configuring-singlestore-on-gcp/csvs/*.csv,outputTopic=projects/$GOOGLE_CLOUD_PROJECT/topics/Taxi
sleep 20
gcloud dataflow flex-template run pstogcs --template-file-gcs-location gs://dataflow-templates-$REGION/latest/flex/Cloud_PubSub_to_GCS_Text_Flex --region $REGION --additional-experiments streaming_mode_exactly_once --parameters inputSubscription=projects/$GOOGLE_CLOUD_PROJECT/subscriptions/Taxi-sub,outputDirectory=gs://$GOOGLE_CLOUD_PROJECT,outputFilenamePrefix=output
