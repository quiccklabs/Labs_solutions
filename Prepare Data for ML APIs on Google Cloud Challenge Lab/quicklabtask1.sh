
echo ""
echo ""
echo "Please enter the regions for the custom network subnets."

# Prompt user to input three regions
read -p "Enter DATASET_NAME: " DATASET_NAME
read -p "Enter BUCKET_NAME: " BUCKET_NAME
read -p "Enter REGION: " REGION
read -p "Enter TABLE_NAME: " TABLE_NAME
read -p "Enter TASK_3_BUCKET_NAME: " TASK_3_BUCKET_NAME
read -p "Enter TASK_4_BUCKET_NAME: " TASK_4_BUCKET_NAME


echo $REGION > /tmp/region.txt  # Save to a temporary file


gcloud services enable apikeys.googleapis.com

gcloud alpha services api-keys create --display-name="quicklab" 

KEY=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=quicklab")

API_KEY=$(gcloud alpha services api-keys get-key-string $KEY --format="value(keyString)")


PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format="json" | jq -r '.projectNumber')
echo $PROJECT_NUMBER

bq mk $DATASET_NAME

gsutil mb gs://$BUCKET_NAME


gsutil cp gs://cloud-training/gsp323/lab.csv  .
  
gsutil cp gs://cloud-training/gsp323/lab.schema .
 
cat lab.schema

echo '[
    {"type":"STRING","name":"guid"},
    {"type":"BOOLEAN","name":"isActive"},
    {"type":"STRING","name":"firstname"},
    {"type":"STRING","name":"surname"},
    {"type":"STRING","name":"company"},
    {"type":"STRING","name":"email"},
    {"type":"STRING","name":"phone"},
    {"type":"STRING","name":"address"},
    {"type":"STRING","name":"about"},
    {"type":"TIMESTAMP","name":"registered"},
    {"type":"FLOAT","name":"latitude"},
    {"type":"FLOAT","name":"longitude"}
]' > lab.schema

bq mk --table $DATASET_NAME.$TABLE_NAME lab.schema



gcloud dataflow jobs run quicklab-jobs --gcs-location gs://dataflow-templates-$REGION/latest/GCS_Text_to_BigQuery --region $REGION --worker-machine-type e2-standard-2 --staging-location gs://$DEVSHELL_PROJECT_ID-marking/temp --parameters inputFilePattern=gs://cloud-training/gsp323/lab.csv,JSONPath=gs://cloud-training/gsp323/lab.schema,outputTable=$DEVSHELL_PROJECT_ID:$DATASET_NAME.$TABLE_NAME,bigQueryLoadingTemporaryDirectory=gs://$DEVSHELL_PROJECT_ID-marking/bigquery_temp,javascriptTextTransformGcsPath=gs://cloud-training/gsp323/lab.js,javascriptTextTransformFunctionName=transform



# gcloud dataproc clusters create cluster-e948 --region $REGION



gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member "serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
    --role "roles/storage.admin"


gcloud compute networks subnets update default \
    --region $REGION \
    --enable-private-ip-google-access




gcloud iam service-accounts create quicklab \
  --display-name "my natural language service account"

gcloud iam service-accounts keys create ~/key.json \
  --iam-account quicklab@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS="/home/$USER/key.json"

gcloud auth activate-service-account quicklab@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --key-file=$GOOGLE_APPLICATION_CREDENTIALS

gcloud ml language analyze-entities --content="Old Norse texts portray Odin as one-eyed and long-bearded, frequently wielding a spear named Gungnir and wearing a cloak and a broad hat." > result.json



gcloud auth login --no-launch-browser --quiet


# TASK 4 BUCKET_NAME

gsutil cp result.json $TASK_4_BUCKET_NAME


cat > request.json <<EOF 
{
  "config": {
      "encoding":"FLAC",
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://cloud-training/gsp323/task3.flac"
  }
}
EOF


curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json


gsutil cp result.json $TASK_3_BUCKET_NAME

gcloud iam service-accounts create quickstart

gcloud iam service-accounts keys create key.json --iam-account quickstart@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com

gcloud auth activate-service-account --key-file key.json

export ACCESS_TOKEN=$(gcloud auth print-access-token)


cat > request.json <<EOF 
{
   "inputUri":"gs://spls/gsp154/video/train.mp4",
   "features": [
       "TEXT_DETECTION"
   ]
}
EOF



curl -s -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    'https://videointelligence.googleapis.com/v1/videos:annotate' \
    -d @request.json



curl -s -H 'Content-Type: application/json' -H "Authorization: Bearer $ACCESS_TOKEN" 'https://videointelligence.googleapis.com/v1/operations/OPERATION_FROM_PREVIOUS_REQUEST' > result1.json

sleep 30

curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json


curl -s -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    'https://videointelligence.googleapis.com/v1/videos:annotate' \
    -d @request.json



curl -s -H 'Content-Type: application/json' -H "Authorization: Bearer $ACCESS_TOKEN" 'https://videointelligence.googleapis.com/v1/operations/OPERATION_FROM_PREVIOUS_REQUEST' > result1.json


