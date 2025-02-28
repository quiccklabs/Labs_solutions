#!/bin/bash



export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

PROJECT_ID=`gcloud config get-value project`



gcloud services enable run.googleapis.com

gcloud services enable cloudfunctions.googleapis.com

curl -LO https://github.com/GoogleCloudPlatform/golang-samples/archive/main.zip

unzip main.zip

cd golang-samples-main/functions/codelabs/gopher

gcloud functions deploy HelloWorld --gen2 --runtime go121 --trigger-http --region $REGION --quiet

gcloud functions deploy Gopher --gen2 --runtime go121 --trigger-http --region $REGION --quiet
