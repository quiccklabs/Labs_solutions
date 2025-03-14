


export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

PROJECT_ID=`gcloud config get-value project`

export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")



#TASK1
gcloud services enable healthcare.googleapis.com

sleep 20

gcloud healthcare datasets create dataset1 --location=$REGION


sleep 50
#TASK 2

SERVICE_ACCOUNT_EMAIL="service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
    --role="roles/storage.objectAdmin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
    --role="roles/healthcare.datasetAdmin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
    --role="roles/healthcare.dicomEditor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
    --role="roles/healthcare.dicomStoreAdmin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com \
--role=roles/storage.objectCreator

gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com \
--role=roles/storage.admin

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="user:$(gcloud config get-value account)" \
    --role="roles/storage.admin"


#TASK 3
# Audit logs

gcloud projects get-iam-policy $PROJECT_ID > policy.yaml

cat <<EOF >> policy.yaml
auditConfigs:
- auditLogConfigs:
  - logType: DATA_READ
  - logType: DATA_WRITE
  service: healthcare.googleapis.com
EOF


gcloud projects set-iam-policy $PROJECT_ID policy.yaml --quiet



#TASK 4

export DATASET_ID=dataset1
export DICOM_STORE_ID=dicomstore1

gcloud beta healthcare dicom-stores create $DICOM_STORE_ID --dataset=$DATASET_ID --location=$REGION

curl -X POST \
     -H "Authorization: Bearer "$(sudo gcloud auth print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
"https://healthcare.googleapis.com/v1beta1/projects/$PROJECT_ID/locations/$REGION/datasets/$DATASET_ID/dicomStores?dicomStoreId=dicomstore2"


#TASK 6

sleep 20

gcloud beta healthcare dicom-stores import gcs $DICOM_STORE_ID --dataset=$DATASET_ID --location=$REGION --gcs-uri=gs://spls/gsp626/LungCT-Diagnosis/R_004/*


#TASK 8

RESPONSE=$(curl -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/json; charset=utf-8" \
    --data "{
      \"destinationDataset\": \"projects/$PROJECT_ID/locations/$REGION/datasets/de-id\",
      \"config\": {
        \"dicom\": {
          \"filterProfile\": \"ATTRIBUTE_CONFIDENTIALITY_BASIC_PROFILE\"
        },
        \"image\": {
          \"textRedactionMode\": \"REDACT_NO_TEXT\"
        }
      }
    }" "https://healthcare.googleapis.com/v1beta1/projects/$PROJECT_ID/locations/$REGION/datasets/$DATASET_ID:deidentify")


OPERATION_ID=$(echo $RESPONSE | jq -r '.name' | awk -F'/' '{print $NF}')

echo "Operation ID: $OPERATION_ID"

curl -X GET \
"https://healthcare.googleapis.com/v1beta1/projects/$PROJECT_ID/locations/$REGION/datasets/$DATASET_ID/operations/$OPERATION_ID" \
-H "Authorization: Bearer "$(sudo gcloud auth print-access-token) \
-H 'Content-Type: application/json; charset=utf-8'


#TASK 9

gsutil mb gs://$PROJECT_ID

SERVICE_ACCOUNT="service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com"

gsutil iam ch serviceAccount:$SERVICE_ACCOUNT:roles/storage.objectCreator gs://$DEVSHELL_PROJECT_ID

gcloud beta healthcare dicom-stores export gcs $DICOM_STORE_ID --dataset=$DATASET_ID --gcs-uri-prefix=gs://$PROJECT_ID/ --mime-type="image/jpeg; transfer-syntax=1.2.840.10008.1.2.4.50" --location=$REGION


gcloud beta healthcare dicom-stores import gcs $DICOM_STORE_ID --dataset=$DATASET_ID --location=$REGION --gcs-uri=gs://spls/gsp626/LungCT-Diagnosis/R_004/*
