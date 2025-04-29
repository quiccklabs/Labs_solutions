export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")


PROJECT_ID=`gcloud config get-value project`

export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")


# echo ""
# echo ""
# echo "Please export the values."



gcloud compute networks create labnet --subnet-mode=custom

gcloud compute networks subnets create labnet-sub \
   --network labnet \
   --region $REGION \
   --range 10.0.0.0/28
