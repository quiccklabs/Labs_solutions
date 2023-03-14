
TASK 1:- 

export BUCKET_ID=<name of bucket>

gsutil mb gs://$BUCKET_ID

gcloud healthcare datasets create dataset1 \
    --location=us-central1


TASK 4-9


export PROJECT_ID=`gcloud config get-value project`
export REGION=us-central1
export DATASET_ID=dataset1
export DICOM_STORE_ID=dicomstore1

gcloud beta healthcare dicom-stores create $DICOM_STORE_ID --dataset=$DATASET_ID --location=$REGION

curl -X POST \
     -H "Authorization: Bearer "$(sudo gcloud auth print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
"https://healthcare.googleapis.com/v1beta1/projects/$PROJECT_ID/locations/$REGION/datasets/$DATASET_ID/dicomStores?dicomStoreId=dicomstore2"


gcloud beta healthcare dicom-stores import gcs $DICOM_STORE_ID --dataset=$DATASET_ID --location=$REGION --gcs-uri=gs://spls/gsp626/LungCT-Diagnosis/R_004/*

gcloud run deploy ohif-viewer --image=gcr.io/qwiklabs-resources/ohif-viewer:latest --platform=managed --region=us-central1 --allow-unauthenticated --set-env-vars=CLIENT_ID=343517506733-kpj2341fuu408u6joptm4sct0tb336jp.apps.googleusercontent.com --max-instances=3


curl -X POST \
    -H "Authorization: Bearer "$(gcloud auth print-access-token) \
    -H "Content-Type: application/json; charset=utf-8" \
    --data "{
      'destinationDataset': 'projects/$PROJECT_ID/locations/$REGION/datasets/de-id',
      'config': {
        'dicom': {
          'filterProfile': 'ATTRIBUTE_CONFIDENTIALITY_BASIC_PROFILE'
        },
        'image': {
          'textRedactionMode': 'REDACT_NO_TEXT'
        }
      }
    }" "https://healthcare.googleapis.com/v1beta1/projects/$PROJECT_ID/locations/$REGION/datasets/$DATASET_ID:deidentify"




curl -X GET \
"https://healthcare.googleapis.com/v1beta1/projects/$PROJECT_ID/locations/$REGION/datasets/$DATASET_ID/operations/<operation-id>" \
-H "Authorization: Bearer "$(sudo gcloud auth print-access-token) \
-H 'Content-Type: application/json; charset=utf-8'


gcloud beta healthcare dicom-stores export gcs $DICOM_STORE_ID --dataset=$DATASET_ID --gcs-uri-prefix=gs://$BUCKET_ID/ --mime-type="image/jpeg; transfer-syntax=1.2.840.10008.1.2.4.50"


gcloud run deploy ohif-viewer11 --image=gcr.io/qwiklabs-resources/ohif-viewer:latest --platform=managed --region=us-central1 --allow-unauthenticated --set-env-vars=CLIENT_ID=343517506733-kpj2341fuu408u6joptm4sct0tb336jp.apps.googleusercontent.com --max-instances=3









