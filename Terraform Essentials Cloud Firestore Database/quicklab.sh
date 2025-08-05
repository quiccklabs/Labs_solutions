

#!/bin/bash

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)



gcloud config set project $PROJECT_ID

gcloud services enable firestore.googleapis.com

gcloud services enable cloudbuild.googleapis.com

gcloud storage buckets create gs://$PROJECT_ID-tf-state --location=us


cat > main.tf <<EOF_END
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  backend "gcs" {
    bucket = "$PROJECT_ID-tf-state"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "$PROJECT_ID"
  region  = "$REGION"
}

resource "google_firestore_database" "default" {
  name     = "default"
  project  = "$PROJECT_ID"
  location_id = "nam5"
  type     = "FIRESTORE_NATIVE"
}

output "firestore_database_name" {
  value       = google_firestore_database.default.name
  description = "The name of the Cloud Firestore database."
}
EOF_END



cat > variables.tf <<EOF_END
variable "project_id" {
  type        = string
  description = "The ID of the Google Cloud project."
  default     = "$PROJECT_ID"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name for terraform state"
  default     = "$PROJECT_ID-tf-state"
}
EOF_END



cat > outputs.tf <<EOF_END
output "project_id" {
  value       = var.project_id
  description = "The ID of the Google Cloud project."
}

output "bucket_name" {
  value       = var.bucket_name
  description = "The name of the bucket to store terraform state."
}
EOF_END


terraform init

terraform plan

terraform apply --auto-approve
