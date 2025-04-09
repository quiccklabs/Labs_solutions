




gcloud services enable compute.googleapis.com container.googleapis.com dataflow.googleapis.com bigquery.googleapis.com pubsub.googleapis.com healthcare.googleapis.com


bq --location=$LOCATION mk --dataset --description HCAPI-dataset $PROJECT_ID:$DATASET_ID

bq --location=$LOCATION mk --dataset --description HCAPI-dataset-de-id $PROJECT_ID:de_id

gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com \
--role=roles/bigquery.dataEditor
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com \
--role=roles/bigquery.jobUser

gcloud healthcare datasets create $DATASET_ID \
--location=$LOCATION



gcloud pubsub topics create fhir-topic



gcloud healthcare fhir-stores create ${FHIR_STORE_ID} \
--dataset=${DATASET_ID} \
--location=${LOCATION} \
--version=R4 \
--pubsub-topic=projects/${PROJECT_ID}/topics/${TOPIC} \
--disable-referential-integrity \
--enable-update-create



gcloud healthcare fhir-stores create de_id \
--dataset=${DATASET_ID} \
--location=${LOCATION} \
--version=R4 \
--pubsub-topic=projects/${PROJECT_ID}/topics/${TOPIC} \
--disable-referential-integrity \
--enable-update-create


gcloud healthcare fhir-stores import gcs $FHIR_STORE_ID \
--dataset=$DATASET_ID \
--location=$LOCATION \
--gcs-uri=gs://spls/gsp457/fhir_devdays_gcp/fhir1/* \
--content-structure=BUNDLE_PRETTY

gcloud healthcare fhir-stores export bq $FHIR_STORE_ID \
--dataset=$DATASET_ID \
--location=$LOCATION \
--bq-dataset=bq://$PROJECT_ID.$DATASET_ID \
--schema-type=analytics


echo -e "\e[1m\e[34mClick here: https://console.cloud.google.com/healthcare/browser/locations/$LOCATION/datasets/$DATASET_ID/datastores?project=$PROJECT_ID\e[0m"
