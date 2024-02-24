

#form 1
gcloud services enable cloudscheduler.googleapis.com

gcloud pubsub topics create cloud-pubsub-topic

gcloud pubsub subscriptions create 'cloud-pubsub-subscription' --topic=cloud-pubsub-topic


 gcloud scheduler jobs create pubsub cron-scheduler-job \
            --schedule="* * * * *" --topic=cron-job-pubsub-topic \
            --message-body="Hello World!" --location=$REGION


gcloud pubsub subscriptions pull cron-job-pubsub-subscription --limit 5


#form3 


gcloud pubsub snapshots create pubsub-snapshot --subscription=gcloud-pubsub-subscription

gcloud pubsub lite-reservations create pubsub-lite-reservation \
    --location=$REGION \
    --throughput-capacity=2


gcloud services enable cloudscheduler.googleapis.com


gcloud pubsub lite-topics create cloud-pubsub-topic-lite \
    --location=$REGION \
    --partitions=1 \
    --per-partition-bytes=30GiB \
    --throughput-reservation=demo-reservation


 gcloud pubsub lite-subscriptions create cloud-pubsub-subscription-lite \
          --location=$REGION --topic=cloud-pubsub-topic-lite



#FORM 2


gcloud beta pubsub schemas create city-temp-schema \
    --type=avro \
    --definition='{
        "type": "record",
        "name": "Avro",
        "fields": [
            {
                "name": "city",
                "type": "string"
            },
            {
                "name": "temperature",
                "type": "double"
            },
            {
                "name": "pressure",
                "type": "int"
            },
            {
                "name": "time_position",
                "type": "string"
            }
        ]
    }'



gcloud pubsub topics create temp-topic \
    --message-encoding=JSON \
    --message-storage-policy-allowed-regions=$REGION \
    --schema=projects/$DEVSHELL_PROJECT_ID/schemas/temperature-schema




mkdir quicklab 
cd quicklab

cat > index.js <<EOF_END
/**
 * Triggered from a message on a Cloud Pub/Sub topic.
 *
 * @param {!Object} event Event payload.
 * @param {!Object} context Metadata for the event.
 */
exports.helloPubSub = (event, context) => {
  const message = event.data
    ? Buffer.from(event.data, 'base64').toString()
    : 'Hello, World';
  console.log(message);
};
EOF_END

cat > package.json <<EOF_END
{
  "name": "sample-pubsub",
  "version": "0.0.1",
  "dependencies": {
    "@google-cloud/pubsub": "^0.18.0"
  }
}

EOF_END



gcloud functions deploy gcf-pubsub \
    --trigger-topic gcf-topic \
    --runtime nodejs20 \
    --region=$REGION \
    --entry-point=helloPubSub \
    --allow-unauthenticated


