

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

sleep 30

cat > run_pubsub_to_gcs_quicklab.sh <<EOF_CP
#!/bin/bash

# Set environment variables
export PROJECT_ID=$PROJECT_ID
export REGION=$REGION
export TOPIC_ID=$TOPIC_ID
export BUCKET_NAME=$BUCKET_NAME

# Clone the repository and navigate to the required directory
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
cd python-docs-samples/pubsub/streaming-analytics

# Install dependencies
pip install -U -r requirements.txt

# Run the Python script with parameters
python PubSubToGCS.py \
  --project=$PROJECT_ID \
  --region=$REGION \
  --input_topic=projects/$PROJECT_ID/topics/$TOPIC_ID \
  --output_path=gs://$BUCKET_NAME/samples/output \
  --runner=DataflowRunner \
  --window_size=2 \
  --num_shards=2 \
  --temp_location=gs://$BUCKET_NAME/temp
EOF_CP

chmod +x run_pubsub_to_gcs_quicklab.sh

gcloud scheduler jobs run quicklab


docker run -it \
  -e DEVSHELL_PROJECT_ID=$DEVSHELL_PROJECT_ID \
  -v "$(pwd)/run_pubsub_to_gcs_quicklab.sh:/run_pubsub_to_gcs_quicklab.sh" \
  python:3.7 \
  /bin/bash -c "/run_pubsub_to_gcs_quicklab.sh"




