




gcloud services disable dataflow.googleapis.com

gcloud services enable dataflow.googleapis.com

sleep 20

bq mk taxirides

bq mk \
--time_partitioning_field timestamp \
--schema ride_id:string,point_idx:integer,latitude:float,longitude:float,\
timestamp:timestamp,meter_reading:float,meter_increment:float,ride_status:string,\
passenger_count:integer -t taxirides.realtime


gsutil mb gs://$DEVSHELL_PROJECT_ID/

sleep 20

gcloud dataflow jobs run iotflow \
    --gcs-location gs://dataflow-templates-$REGION/latest/PubSub_to_BigQuery \
    --region $REGION \
    --worker-machine-type e2-medium \
    --staging-location gs://$DEVSHELL_PROJECT_ID/temp \
    --parameters inputTopic=projects/pubsub-public-data/topics/taxirides-realtime,outputTableSpec=$DEVSHELL_PROJECT_ID:taxirides.realtime