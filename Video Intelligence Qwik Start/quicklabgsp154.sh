

gcloud iam service-accounts create quickstart

gcloud iam service-accounts keys create key.json --iam-account quickstart@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com

gcloud auth activate-service-account --key-file key.json

gcloud auth print-access-token

cat > request.json <<EOF
{
   "inputUri":"gs://spls/gsp154/video/train.mp4",
   "features": [
       "LABEL_DETECTION"
   ]
}
EOF


# Run the initial annotation request
response=$(curl -s -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer '$(gcloud auth print-access-token)'' \
    'https://videointelligence.googleapis.com/v1/videos:annotate' \
    -d @request.json)

# Extract the project ID, location, and operation name from the response using jq
project_id=$(echo $response | jq -r '.name' | cut -d'/' -f2)
location=$(echo $response | jq -r '.name' | cut -d'/' -f4)
operation_name=$(echo $response | jq -r '.name' | cut -d'/' -f6)

# Use the extracted values in the subsequent command
curl -s -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer '$(gcloud auth print-access-token)'' \
    "https://videointelligence.googleapis.com/v1/projects/$project_id/locations/$location/operations/$operation_name"



