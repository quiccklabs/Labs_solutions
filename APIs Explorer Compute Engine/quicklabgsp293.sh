


export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")


PROJECT_ID=`gcloud config get-value project`

export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")



gcloud compute instances create instance-1 \
  --project=$PROJECT_ID \
  --zone=$ZONE \
  --machine-type=n1-standard-1 \
  --image-family=debian-11 \
  --image-project=debian-cloud \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=instance-1



gcloud compute instances delete instance-1 \
  --project=$PROJECT_ID \
  --zone=$ZONE --quiet
