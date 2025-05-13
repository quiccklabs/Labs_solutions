
#!/bin/bash

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)




gcloud logging metrics create 200responses \
  --description="Counts 200 OK responses from the default App Engine service" \
  --log-filter='resource.type="gae_app" AND resource.labels.module_id="default" AND (protoPayload.status=200 OR httpRequest.status=200)'


cat > latency_metric.yaml <<EOF
name: projects/\$DEVSHELL_PROJECT_ID/metrics/latency_metric
description: "latency distribution"
filter: >
  resource.type="gae_app"
  resource.labels.module_id="default"
  (protoPayload.status=200 OR httpRequest.status=200)
  logName=("projects/\$DEVSHELL_PROJECT_ID/logs/cloudbuild" OR
           "projects/\$DEVSHELL_PROJECT_ID/logs/stderr" OR
           "projects/\$DEVSHELL_PROJECT_ID/logs/%2Fvar%2Flog%2Fgoogle_init.log" OR
           "projects/\$DEVSHELL_PROJECT_ID/logs/appengine.googleapis.com%2Frequest_log" OR
           "projects/\$DEVSHELL_PROJECT_ID/logs/cloudaudit.googleapis.com%2Factivity")
  severity>=DEFAULT
valueExtractor: EXTRACT(protoPayload.latency)
metricDescriptor:
  metricKind: DELTA
  valueType: DISTRIBUTION
  unit: "s"
  displayName: "Latency distribution"
bucketOptions:
  exponentialBuckets:
    numFiniteBuckets: 10
    growthFactor: 2.0
    scale: 0.01
EOF


export DEVSHELL_PROJECT_ID=$(gcloud config get-value project)
gcloud logging metrics create latency_metric --config-from-file=latency_metric.yaml


#TASK 7

gcloud compute instances create audit-log-vm \
  --zone=$ZONE \
  --machine-type=e2-micro \
  --image-family=debian-11 \
  --image-project=debian-cloud \
  --tags=http-server \
  --metadata=startup-script='#!/bin/bash
    sudo apt update && sudo apt install -y apache2
    sudo systemctl start apache2' \
  --scopes=https://www.googleapis.com/auth/cloud-platform \
  --labels=env=lab \
  --quiet




#TASK 8

# Set variables
PROJECT_ID=$(gcloud config get-value project)
SINK_NAME="AuditLogs"
BQ_DATASET="AuditLogs"
BQ_LOCATION="US"  

# Create BigQuery dataset if not exists
bq --location=$BQ_LOCATION mk --dataset $PROJECT_ID:$BQ_DATASET

# Create the sink
gcloud logging sinks create $SINK_NAME \
  bigquery.googleapis.com/projects/$PROJECT_ID/datasets/$BQ_DATASET \
  --log-filter='resource.type="gce_instance"
logName="projects/'$PROJECT_ID'/logs/cloudaudit.googleapis.com%2Factivity"' \
  --description="Export GCE audit logs to BigQuery" \
  --project=$PROJECT_ID


echo -e "\033[1;36m\033[1mClick here\033[0m ➡️ https://console.cloud.google.com/appengine?project="

