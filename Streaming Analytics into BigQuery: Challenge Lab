
export BUCKET_NAME=

export DATASET_NAME=

export TABLE_NAME=

export TOPIC_NAME=



gsutil mb gs://$BUCKET_NAME

bq mk $DATASET_NAME

bq mk --table \
$DEVSHEL_PROJECT_ID:$DATASET_NAME.$TABLE_NAME \
data:string

gcloud pubsub topics create $TOPIC_NAME

gcloud pubsub subscriptions create $TOPIC_NAME-sub --topic=$TOPIC_NAME

