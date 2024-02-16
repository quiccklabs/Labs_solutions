

gcloud config list --format 'value(core.project)'


cat > main.tf <<EOF_END
provider "google" {
  project     = "$DEVSHELL_PROJECT_ID"
  region      = "$REGION"
}
resource "google_storage_bucket" "test-bucket-for-state" {
  name        = "$DEVSHELL_PROJECT_ID"
  location    = "US" # Replace with EU for Europe region
  uniform_bucket_level_access = true
}
terraform {
  backend "local" {
    path = "terraform/state/terraform.tfstate"
  }
}
EOF_END

terraform init 

terraform apply --auto-approve


cat > main.tf <<EOF_END
provider "google" {
  project     = "$DEVSHELL_PROJECT_ID"
  region      = "$REGION"
}
resource "google_storage_bucket" "test-bucket-for-state" {
  name        = "$DEVSHELL_PROJECT_ID"
  location    = "US" # Replace with EU for Europe region
  uniform_bucket_level_access = true
}
terraform {
  backend "gcs" {
    bucket  = "$DEVSHELL_PROJECT_ID"
    prefix  = "terraform/state"
  }
}
EOF_END


echo "yes" | terraform init -migrate-state 

gcloud storage buckets update gs://$DEVSHELL_PROJECT_ID --update-labels=key=value

terraform refresh


cat > main.tf <<EOF_END
provider "google" {
  project     = "$DEVSHELL_PROJECT_ID"
  region      = "$REGION"
}
resource "google_storage_bucket" "test-bucket-for-state" {
  name        = "$DEVSHELL_PROJECT_ID"
  location    = "US" # Replace with EU for Europe region
  uniform_bucket_level_access = true
  force_destroy = true

}
terraform {
  backend "local" {
    path = "terraform/state/terraform.tfstate"
  }
}
EOF_END

echo "yes" | terraform init -migrate-state 


terraform apply --auto-approve

terraform destroy --auto-approve





gcloud config list --format 'value(core.project)'


cat > main.tf <<EOF_END
provider "google" {
  project     = "$DEVSHELL_PROJECT_ID"
  region      = "$REGION"
}
resource "google_storage_bucket" "test-bucket-for-state" {
  name        = "$DEVSHELL_PROJECT_ID"
  location    = "US" # Replace with EU for Europe region
  uniform_bucket_level_access = true
}
terraform {
  backend "local" {
    path = "terraform/state/terraform.tfstate"
  }
}
EOF_END

terraform init 

terraform apply --auto-approve


cat > main.tf <<EOF_END
provider "google" {
  project     = "$DEVSHELL_PROJECT_ID"
  region      = "$REGION"
}
resource "google_storage_bucket" "test-bucket-for-state" {
  name        = "$DEVSHELL_PROJECT_ID"
  location    = "US" # Replace with EU for Europe region
  uniform_bucket_level_access = true
}
terraform {
  backend "gcs" {
    bucket  = "$DEVSHELL_PROJECT_ID"
    prefix  = "terraform/state"
  }
}
EOF_END


echo "yes" | terraform init -migrate-state 

gcloud storage buckets update gs://$DEVSHELL_PROJECT_ID --update-labels=key=value

terraform refresh
