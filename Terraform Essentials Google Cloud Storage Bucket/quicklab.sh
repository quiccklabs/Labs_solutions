

#!/bin/bash

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)



gcloud config set project $PROJECT_ID

gcloud config set compute/region $REGION

gcloud config set compute/zone $ZONE



gcloud storage buckets create gs://$PROJECT_ID-tf-state --project=$PROJECT_ID --location=$REGION --uniform-bucket-level-access

gsutil versioning set on gs://$PROJECT_ID-tf-state

mkdir terraform-gcs && cd $_

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

resource "google_storage_bucket" "default" {
  name          = "$PROJECT_ID-my-terraform-bucket"
  location      = "$REGION"
  force_destroy = true

  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}
EOF_END



# cat > variables.tf <<EOF_END
# variable "project_id" {
#   type        = string
#   description = "The ID of the Google Cloud project"
#   default = "$PROJECT_ID"
# }

# variable "region" {
#   type        = string
#   description = "The region to deploy resources in"
#   default     = "$REGION"
# }

# variable "zone" {
#   type        = string
#   description = "The zone to deploy resources in"
#   default     = "$ZONE"
# }
# EOF_END



# cat > outputs.tf <<EOF_END
# output "project_id" {
#   value       = var.project_id
#   description = "The ID of the Google Cloud project."
# }

# output "bucket_name" {
#   value       = var.bucket_name
#   description = "The name of the bucket to store terraform state."
# }
# EOF_END


terraform init

terraform plan

terraform apply --auto-approve
