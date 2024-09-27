echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter REGION: " REGION


PROJECT_ID=$(gcloud config get-value project)
echo "PROJECT_ID=${PROJECT_ID}"

USER=$(gcloud config get-value account 2> /dev/null)
echo "USER=${USER}"

gcloud services enable cloudaicompanion.googleapis.com --project ${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/cloudaicompanion.user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/serviceusage.serviceUsageViewer


gcloud workstations configs create my-config \
  --cluster=my-cluster \
  --region=$REGION 

sleep 60

gcloud workstations create my-workstation \
  --config=my-config \
  --cluster=my-cluster \
  --region=$REGION 

sleep 20


gcloud workstations start my-workstation \
  --config=my-config \
  --cluster=my-cluster \
  --region=$REGION 



#!/bin/bash

bq load --source_format=CSV --autodetect cymbal_sales.cymbalsalestable gs://$DEVSHELL_PROJECT_ID-cymbal-frontend/sales_bq_rawdata.csv

bq query --use_legacy_sql=false \
"
 SELECT * FROM \`$DEVSHELL_PROJECT_ID.cymbal_sales.cymbalsalestable\` LIMIT 1000
 "

bq query --use_legacy_sql=false \
"
 SELECT SUM(PRICE_PER_UNIT * QUANTITY_SOLD_AUG_5) AS total_aug_5 FROM \`$DEVSHELL_PROJECT_ID.cymbal_sales.cymbalsalestable\`;
 "



# ANSI escape codes for bold and green
BOLD_GREEN="\033[1;32m"
RESET="\033[0m"

# Print the URL in bold and green
echo -e "${BOLD_GREEN}https://console.cloud.google.com/workstations/list?project=${RESET}"
