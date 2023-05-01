

export PROJECT_ID=

TASK 1:- 

export PROJECT_ID=$(gcloud config get-value project)
gcloud services enable bigquery.googleapis.com \
    cloudbuild.googleapis.com \
    composer.googleapis.com \
    storage-component.googleapis.com \
    cloudresourcemanager.googleapis.com


TASK 2:-

bq mk --dataset CDC_PROCESSED
bq mk --dataset SAP_REPLICATED_DATA
bq mk --dataset SAP_REPORTING



TASK 4:-

gsutil mb -l US gs://$PROJECT_ID-sap-cortex
export GCS_BUCKET=$PROJECT_ID-sap-cortex


TASK 5:-

cd ~

git clone --recurse-submodules https://github.com/GoogleCloudPlatform/cortex-data-foundation

cd cortex-data-foundation

gcloud builds submit --project $PROJECT_ID \
--substitutions \
_PJID_SRC=$PROJECT_ID,_PJID_TGT=$PROJECT_ID,_DS_CDC=CDC_PROCESSED,_DS_RAW=SAP_REPLICATED_DATA,_DS_REPORTING=SAP_REPORTING,_GCS_BUCKET=$GCS_BUCKET,_TGT_BUCKET=$GCS_BUCKET,_TEST_DATA=true,_DEPLOY_CDC=true





