export PROCESSOR_NAME=form-parser

export PROCESSOR_NAME_2=ocr-processor


export PROJECT_ID=$(gcloud config get-value core/project)

gcloud services enable documentai.googleapis.com      
gcloud services enable cloudfunctions.googleapis.com  
gcloud services enable cloudbuild.googleapis.com    
gcloud services enable geocoding-backend.googleapis.com 
gcloud services enable eventarc.googleapis.com
gcloud services enable run.googleapis.com


ACCESS_TOKEN=$(gcloud auth application-default print-access-token)

curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "display_name": "'"$PROCESSOR_NAME"'",
    "type": "FORM_PARSER_PROCESSOR"
  }' \
  "https://documentai.googleapis.com/v1/projects/$PROJECT_ID/locations/us/processors"



curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "display_name": "'"$PROCESSOR_NAME_2"'",
    "type": "OCR_PROCESSOR"
  }' \
  "https://documentai.googleapis.com/v1/projects/$PROJECT_ID/locations/us/processors"


echo -e "\033[1;34mVertex AI\033[0m - \033[1;33mhttps://console.cloud.google.com/vertex-ai?referrer=search&project=$PROJECT_ID\033[0m"
echo -e "\033[1;34mMy Processor\033[0m - \033[1;33mhttps://console.cloud.google.com/ai/document-ai/processors?project=$PROJECT_ID\033[0m"
