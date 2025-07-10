
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")

gcloud artifacts repositories create my-maven-repo \
    --repository-format=maven \
    --location=$REGION \
    --description="Maven repository"
