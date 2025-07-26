
#!/bin/bash

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)



gcloud services enable artifactregistry.googleapis.com

gcloud config set project $PROJECT_ID

gcloud config set compute/region $REGION

gcloud artifacts repositories create my-docker-repo \
    --repository-format=docker \
    --location=$REGION \
    --description="Docker repository"

