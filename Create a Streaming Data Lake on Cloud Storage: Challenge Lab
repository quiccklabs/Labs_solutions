

PROJECT_ID=$(gcloud config get-value project)

export BUCKET_NAME="${PROJECT_ID}-bucket"

export TOPIC_ID=

export REGION=

export MESSAGE=""

gcloud services disable dataflow.googleapis.com

gcloud services enable dataflow.googleapis.com

gsutil mb gs://$BUCKET_NAME

gcloud pubsub topics create $TOPIC_ID

gcloud app create --region=$REGION

sleep 100

gcloud scheduler jobs create pubsub quicklab --schedule="* * * * *" \
    --topic=$TOPIC_ID --message-body="$MESSAGE"


gcloud scheduler jobs run quicklab

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





