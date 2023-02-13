

echo ${GOOGLE_CLOUD_PROJECT}

export SPLUNK_HOSTNAME=prd-p-saen7.splunkcloud.com
export SC4K_HEC_TOKEN=bc77efcf-fc60-494f-b80c-52701d7901d4
export DATAFLOW_HEC_TOKEN=bf4bae6f-f9c8-4f5c-b349-3cf77c9baa16

# Common
export SINK_NAME=splunk-dataflow-sink-cli
export SINK_TOPIC=splunk-dataflow-sink
export DISABLE_CERT_VALIDATION=true
# Dataflow
export DEADLETTER_TOPIC=splunk-dataflow-deadletter
export DATAFLOW_SUB=dataflow-sub
export DEADLETTER_SUB=deadletter-sub
export MAX_WORKERS=4
export MACHINE=n1-standard-1
export HEC_URL=https://${SPLUNK_HOSTNAME}:8088
export BATCH_COUNT=10
export PARALLELISM=4
export DATAFLOW_FORMAT_LIKE_PUBSUB=true
# GCP-TA
export SPLUNK_SERVICE_ACCOUNT=splunk-ta
export TA_SUBSCRIPTION=ta-subscription

gcloud pubsub topics create ${SINK_TOPIC}

gcloud logging sinks create ${SINK_NAME} \
pubsub.googleapis.com/projects/${GOOGLE_CLOUD_PROJECT}/topics/${SINK_TOPIC} \
--log-filter="resource.type!=\"dataflow_step\""


export SERVICE_ACCOUNT=`gcloud logging sinks describe ${SINK_NAME} --format="value(writerIdentity)"`


gcloud pubsub topics add-iam-policy-binding ${SINK_TOPIC} \
--member="${SERVICE_ACCOUNT}" --role="roles/pubsub.publisher"


gcloud services enable dataflow.googleapis.com


gsutil mb -l us-central1 gs://${GOOGLE_CLOUD_PROJECT}-dataflow


gcloud pubsub topics create ${DEADLETTER_TOPIC}
gcloud pubsub subscriptions create ${DEADLETTER_SUB} \
--topic ${DEADLETTER_TOPIC}

gcloud pubsub subscriptions create ${DATAFLOW_SUB} \
--topic ${SINK_TOPIC}


gcloud dataflow jobs run splunk-dataflow-`date +%s` \
--region us-central1 \
--gcs-location=gs://dataflow-templates/latest/Cloud_PubSub_to_Splunk \
  --staging-location=gs://${GOOGLE_CLOUD_PROJECT}-dataflow/tmp \
  --max-workers=${MAX_WORKERS} \
  --worker-machine-type=${MACHINE} \
  --parameters="\
inputSubscription=projects/${GOOGLE_CLOUD_PROJECT}/subscriptions/${DATAFLOW_SUB},\
token=${DATAFLOW_HEC_TOKEN},\
url=${HEC_URL},\
outputDeadletterTopic=projects/${GOOGLE_CLOUD_PROJECT}/topics/${DEADLETTER_TOPIC},\
batchCount=${BATCH_COUNT},\
parallelism=${PARALLELISM},\
includePubsubMessage=${DATAFLOW_FORMAT_LIKE_PUBSUB},\
disableCertificateValidation=${DISABLE_CERT_VALIDATION}"


gcloud iam service-accounts create ${SPLUNK_SERVICE_ACCOUNT} --description "Subscribe To Quicklab"


gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
--member=serviceAccount:${SPLUNK_SERVICE_ACCOUNT}@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --role=roles/compute.admin
gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
--member=serviceAccount:${SPLUNK_SERVICE_ACCOUNT}@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --role=roles/storage.admin
gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
--member=serviceAccount:${SPLUNK_SERVICE_ACCOUNT}@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --role=roles/storage.objectViewer
gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
--member=serviceAccount:${SPLUNK_SERVICE_ACCOUNT}@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --role=roles/logging.configWriter
gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
--member=serviceAccount:${SPLUNK_SERVICE_ACCOUNT}@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --role=roles/monitoring.viewer
gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
--member=serviceAccount:${SPLUNK_SERVICE_ACCOUNT}@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --role=roles/logging.viewer
gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
--member=serviceAccount:${SPLUNK_SERVICE_ACCOUNT}@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --role=roles/viewer
gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
--member=serviceAccount:${SPLUNK_SERVICE_ACCOUNT}@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --role=roles/pubsub.viewer



gcloud iam service-accounts keys create \
 ${SPLUNK_SERVICE_ACCOUNT}.json \
 --iam-account=${SPLUNK_SERVICE_ACCOUNT}@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
cat ${SPLUNK_SERVICE_ACCOUNT}.json



gcloud pubsub subscriptions create ${TA_SUBSCRIPTION} \
--topic ${SINK_TOPIC}


gcloud pubsub subscriptions add-iam-policy-binding ${TA_SUBSCRIPTION} \
--member=serviceAccount:${SPLUNK_SERVICE_ACCOUNT}@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --role=roles/pubsub.subscriber


gsutil cp \
 gs://${GOOGLE_CLOUD_PROJECT}-dashboard/SplunkExportDashboard.json .
gcloud alpha monitoring dashboards create \
 --config-from-file=SplunkExportDashboard.json \
 --project=${GOOGLE_CLOUD_PROJECT}








