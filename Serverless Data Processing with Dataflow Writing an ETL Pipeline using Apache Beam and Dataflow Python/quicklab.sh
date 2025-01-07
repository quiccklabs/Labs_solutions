
echo ""
echo ""

read -p "ENTER REGION: " REGION


git clone https://github.com/GoogleCloudPlatform/training-data-analyst
cd /home/jupyter/training-data-analyst/quests/dataflow_python/

cd 1_Basic_ETL/lab
export BASE_DIR=$(pwd)


sudo apt-get update && sudo apt-get install -y python3-venv

python3 -m venv df-env

source df-env/bin/activate

python3 -m pip install -q --upgrade pip setuptools wheel
python3 -m pip install apache-beam[gcp]

gcloud services enable dataflow.googleapis.com


cd $BASE_DIR/../..

source create_batch_sinks.sh

bash generate_batch_events.sh

head events.json

cd ~/training-data-analyst/quests/dataflow_python/1_Basic_ETL/lab

rm my_pipeline.py

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/refs/heads/master/Serverless%20Data%20Processing%20with%20Dataflow%20Writing%20an%20ETL%20Pipeline%20using%20Apache%20Beam%20and%20Dataflow%20Python/my_pipeline.py


cd training-data-analyst/quests/dataflow_python

cd $BASE_DIR

# Set up environment variables
export PROJECT_ID=$(gcloud config get-value project)

# Run the pipeline
python3 my_pipeline.py \
  --project=${PROJECT_ID} \
  --region=$REGION \
  --stagingLocation=gs://$PROJECT_ID/staging/ \
  --tempLocation=gs://$PROJECT_ID/temp/ \
  --runner=DirectRunner



# Set up environment variables
cd $BASE_DIR
export PROJECT_ID=$(gcloud config get-value project)

# Run the pipelines
python3 my_pipeline.py \
  --project=${PROJECT_ID} \
  --region=$REGION \
  --stagingLocation=gs://$PROJECT_ID/staging/ \
  --tempLocation=gs://$PROJECT_ID/temp/ \
  --runner=DataflowRunner


cd $BASE_DIR/../..
bq show --schema --format=prettyjson logs.logs


bq show --schema --format=prettyjson logs.logs | sed '1s/^/{"BigQuery Schema":/' | sed '$s/$/}/' > schema.json

cat schema.json

export PROJECT_ID=$(gcloud config get-value project)
gcloud storage cp schema.json gs://${PROJECT_ID}/


cat > transform.js <<EOF_END
function transform(line) {
  return line;
}
EOF_END

export PROJECT_ID=$(gcloud config get-value project)
gcloud storage cp *.js gs://${PROJECT_ID}/


# Task 3

gcloud config set project $PROJECT_ID


gcloud dataflow jobs run quicklab-job --gcs-location gs://dataflow-templates-$REGION/latest/GCS_Text_to_BigQuery --region $REGION --staging-location gs://$PROJECT_ID/tmp --parameters inputFilePattern=gs://$PROJECT_ID/events.json,JSONPath=gs://$PROJECT_ID/schema.json,outputTable=$PROJECT_ID:logs.logs,bigQueryLoadingTemporaryDirectory=gs://$PROJECT_ID/tmp,javascriptTextTransformGcsPath=gs://$PROJECT_ID/transform.js,javascriptTextTransformFunctionName=transform
