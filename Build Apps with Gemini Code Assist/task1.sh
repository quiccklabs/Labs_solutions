export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

PROJECT_ID=`gcloud config get-value project`



export PROJECT_ID=$(gcloud config list project --format="value(core.project)")
export USER=$(gcloud config list account --format "value(core.account)")
echo "PROJECT_ID=${PROJECT_ID}"
echo "USER=${USER}"
echo "REGION=${REGION}"


gcloud services enable cloudaicompanion.googleapis.com --project ${PROJECT_ID}
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/cloudaicompanion.user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/serviceusage.serviceUsageViewer


sleep 30


export CLUSTER_NAME=my-cluster
export CONFIG_NAME=my-config
export WS_NAME=my-workstation
gcloud workstations configs create ${CONFIG_NAME} --cluster=${CLUSTER_NAME} --region=${REGION} --machine-type="e2-standard-4" --pd-disk-size=200 --pd-disk-type="pd-standard" --pool-size=1
gcloud workstations create ${WS_NAME} --cluster=${CLUSTER_NAME} --config=${CONFIG_NAME} --region=${REGION}

