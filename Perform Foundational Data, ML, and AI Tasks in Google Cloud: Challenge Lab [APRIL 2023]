Perform Foundational Data, ML, and AI Tasks in Google Cloud: Challenge Lab


Task - 1 : Run a simple Dataflow job

bq mk DATASET_NAME

gsutil mb gs://BUCKET_NAME


gsutil cp gs://cloud-training/gsp323/lab.csv  .
  
gsutil cp gs://cloud-training/gsp323/lab.schema .
 
cat lab.schema


Task - 2 : Run a simple Dataproc job
This has to be done mannually.



TASK 3 & TASK 4:-


Create an API key and export as API_KEY variable


export API_KEY={Replace with API KEY}

export TASK_3_BUCKET_NAME=

export TASK_4_BUCKET_NAME=


gcloud iam service-accounts create quicklab \
  --display-name "my natural language service account"

gcloud iam service-accounts keys create ~/key.json \
  --iam-account quicklab@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS="/home/$USER/key.json"

gcloud auth activate-service-account quicklab@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --key-file=$GOOGLE_APPLICATION_CREDENTIALS

gcloud ml language analyze-entities --content="Old Norse texts portray Odin as one-eyed and long-bearded, frequently wielding a spear named Gungnir and wearing a cloak and a broad hat." > result.json



gcloud auth login --no-launch-browser


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









