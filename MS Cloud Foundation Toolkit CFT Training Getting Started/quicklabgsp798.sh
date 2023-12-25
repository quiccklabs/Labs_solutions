


gcloud services enable storage-api.googleapis.com

sleep 20

git clone https://github.com/terraform-google-modules/cloud-foundation-training.git

cd cloud-foundation-training/01-Getting-Started


rm main.tf

cat <<'EOF' > main.tf
provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_providers {
    google = {
      version = "~> 4.0"
    }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "remote_state" {
  name          = "cft-lab-state-${var.project_id}-${random_id.suffix.hex}"
  location      = "US"
  force_destroy = true

  versioning {
    enabled = true
  }
}
EOF





cat > terraform.tfvars <<EOF_END
project_id = "$DEVSHELL_PROJECT_ID"
region              = "$REGION"

EOF_END


cat > variables.tf <<EOF_END
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}
EOF_END


cat > output.tf <<EOF_END
output "remote_state_bucket" {
    value = google_storage_bucket.remote_state.url
}
EOF_END


terraform init

terraform plan

terraform plan -out=plan.out

terraform apply plan.out


export REMOTE_STATE_BUCKET=$(gsutil list | grep "^gs://cft-lab-state" | head -n 1 | sed 's/gs:\/\///;s/\/$//')


cat > backend.tf <<EOF_END
terraform {
  backend "gcs" {
    bucket  = ""
    prefix  = "terraform/state/01/"
  }
}
EOF_END


sed -i "3s|.*|    bucket  = \"${REMOTE_STATE_BUCKET}\"|" backend.tf

terraform init -force-copy
