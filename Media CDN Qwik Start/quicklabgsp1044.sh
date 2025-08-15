

#!/bin/bash

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)



gcloud services enable networkservices.googleapis.com
gcloud services enable certificatemanager.googleapis.com

# 1. Create the bucket
gsutil mb gs://$PROJECT_ID/

# 2. Remove Public Access Prevention
gsutil pap set unspecified gs://$PROJECT_ID/

# 3. Grant public read access to objects in the bucket
gsutil iam ch allUsers:objectViewer gs://$PROJECT_ID/
