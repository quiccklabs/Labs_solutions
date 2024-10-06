




echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter PROCESSOR_NAME: " PROCESSOR_NAME
read -p "Enter REGION: " REGION




#TASK 1
export BUCKET_LOCATION=$REGION
export PROJECT_ID=$(gcloud config get-value core/project)

gcloud services enable documentai.googleapis.com      
gcloud services enable cloudfunctions.googleapis.com  
gcloud services enable cloudbuild.googleapis.com    
gcloud services enable geocoding-backend.googleapis.com 
gcloud services enable eventarc.googleapis.com
gcloud services enable run.googleapis.com

mkdir ./document-ai-challenge
gsutil -m cp -r gs://spls/gsp367/* \
~/document-ai-challenge/

#TASK 2

ACCESS_TOKEN=$(gcloud auth application-default print-access-token)

curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "display_name": "'"$PROCESSOR_NAME"'",
    "type": "FORM_PARSER_PROCESSOR"
  }' \
  "https://documentai.googleapis.com/v1/projects/$PROJECT_ID/locations/us/processors"


gsutil mb -c standard -l ${BUCKET_LOCATION} -b on \
 gs://${PROJECT_ID}-input-invoices
gsutil mb -c standard -l ${BUCKET_LOCATION} -b on \
 gs://${PROJECT_ID}-output-invoices
gsutil mb -c standard -l ${BUCKET_LOCATION} -b on \
 gs://${PROJECT_ID}-archived-invoices


#TASK 3
#Create a BigQuery dataset and tables

bq --location="US" mk  -d \
    --description "Form Parser Results" \
    ${PROJECT_ID}:invoice_parser_results
cd ~/documentai-pipeline-demo/scripts/table-schema/
bq mk --table \
invoice_parser_results.doc_ai_extracted_entities \
doc_ai_extracted_entities.json
bq mk --table \
invoice_parser_results.geocode_details \
geocode_details.json


#TASK 4


cd ~/document-ai-challenge/scripts 

export PROJECT_ID=$(gcloud config get-value core/project)
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
  --role="roles/artifactregistry.reader"

export CLOUD_FUNCTION_LOCATION=$REGION

sleep 20

deploy_function() {
gcloud functions deploy process-invoices \
--region=${CLOUD_FUNCTION_LOCATION} \
--entry-point=process_invoice \
--runtime=python39 \
--service-account=${PROJECT_ID}@appspot.gserviceaccount.com \
--source=cloud-functions/process-invoices \
--timeout=400 \
--env-vars-file=cloud-functions/process-invoices/.env.yaml \
--trigger-resource=gs://${PROJECT_ID}-input-invoices \
--trigger-event=google.storage.object.finalize \
--no-gen2
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully, Don't forgot to subscribe to quicklab:)(https://www.youtube.com/@quick_lab)"
    deploy_success=true
  else
    echo "Deployment Retrying, please subscribe to quicklab (https://www.youtube.com/@quick_lab).."
    sleep 10
  fi
done


# Run the curl command and use grep and sed to extract the processor ID
PROCESSOR_ID=$(curl -X GET \
  -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
  -H "Content-Type: application/json" \
  "https://documentai.googleapis.com/v1/projects/$PROJECT_ID/locations/us/processors" | \
  grep '"name":' | \
  sed -E 's/.*"name": "projects\/[0-9]+\/locations\/us\/processors\/([^"]+)".*/\1/')

# Export the variable
export PROCESSOR_ID


gcloud functions deploy process-invoices \
  --region=${CLOUD_FUNCTION_LOCATION} \
  --entry-point=process_invoice \
  --runtime=python39 \
  --source=cloud-functions/process-invoices \
  --timeout=400 \
  --trigger-resource=gs://${PROJECT_ID}-input-invoices \
  --trigger-event=google.storage.object.finalize \
  --update-env-vars=PROCESSOR_ID=${PROCESSOR_ID},PARSER_LOCATION=us,PROJECT_ID=${PROJECT_ID} \
  --service-account=$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
  --no-gen2



#Task 5. Test and validate the end-to-end solution


export PROJECT_ID=$(gcloud config get-value core/project)
gsutil -m cp -r gs://cloud-training/gsp367/* \
~/document-ai-challenge/invoices gs://${PROJECT_ID}-input-invoices/
