


gcloud services enable compute.googleapis.com container.googleapis.com dataflow.googleapis.com bigquery.googleapis.com pubsub.googleapis.com healthcare.googleapis.com

gcloud healthcare datasets create dataset1 --location=${REGION}

sleep 40

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
export PROJECT_NUMBER=$(gcloud projects list --filter=projectId:$PROJECT_ID --format="value(projectNumber)")
gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com --role=roles/bigquery.admin
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com \
--role=roles/storage.objectAdmin
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com \
--role=roles/healthcare.datasetAdmin
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com \
--role=roles/healthcare.dicomStoreAdmin


gcloud healthcare dicom-stores create $DICOM_STORE_ID \
  --dataset=$DATASET_ID \
  --location=$REGION

curl -X POST \
     -H "Authorization: Bearer "$(sudo gcloud auth print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
"https://healthcare.googleapis.com/v1beta1/projects/$PROJECT_ID/locations/$REGION/datasets/$DATASET_ID/dicomStores?dicomStoreId=dicomstore2"

gcloud healthcare dicom-stores import gcs $DICOM_STORE_ID \
  --dataset=$DATASET_ID \
  --location=$REGION \
  --gcs-uri=gs://gcs-public-data--healthcare-nih-chest-xray/dicom/000000*.dcm


bq mk --dataset --location=us-east4 --description DICOM $PROJECT_ID:$DATASET_ID

curl -X POST \
    -H "Authorization: Bearer "$(gcloud auth print-access-token) \
    -H "Content-Type: application/json; charset=utf-8" \
    --data "{
      'bigqueryDestination': {
        'tableUri': 'bq://$PROJECT_ID.$DATASET_ID.$DICOM_STORE_ID'
      }
    }" "https://healthcare.googleapis.com/v1beta1/projects/$PROJECT_ID/locations/$REGION/datasets/$DATASET_ID/dicomStores/$DICOM_STORE_ID:export"