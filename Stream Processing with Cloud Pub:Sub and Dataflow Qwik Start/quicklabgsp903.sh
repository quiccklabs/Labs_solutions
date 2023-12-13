


gcloud config set compute/region $REGION

gcloud services disable dataflow.googleapis.com
gcloud services enable dataflow.googleapis.com
gcloud services enable cloudscheduler.googleapis.com

sleep 20

PROJECT_ID=$(gcloud config get-value project)
BUCKET_NAME="${PROJECT_ID}-bucket"
TOPIC_ID=my-id

gsutil mb gs://$BUCKET_NAME

gcloud pubsub topics create $TOPIC_ID

if [ "$REGION" == "us-central1" ]; then
  gcloud app create --region us-central
else
  gcloud app create --region "$REGION"
fi

gcloud scheduler jobs create pubsub publisher-job --schedule="* * * * *" \
    --topic=$TOPIC_ID --message-body="Hello!"

gcloud scheduler jobs run publisher-job

git clone https://github.com/GoogleCloudPlatform/java-docs-samples.git
cd java-docs-samples/pubsub/streaming-analytics

mvn compile exec:java \
-Dexec.mainClass=com.examples.pubsub.streaming.PubSubToGcs \
-Dexec.cleanupDaemonThreads=false \
-Dexec.args=" \
    --project=$PROJECT_ID \
    --region=$REGION \
    --inputTopic=projects/$PROJECT_ID/topics/$TOPIC_ID \
    --output=gs://$BUCKET_NAME/samples/output \
    --runner=DataflowRunner \
    --windowSize=2"








