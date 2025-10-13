#!/bin/bash


# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)


gcloud services enable firestore.googleapis.com

gcloud firestore databases create \
  --database="sports" \
  --location="$REGION" \
  --type=firestore-native


