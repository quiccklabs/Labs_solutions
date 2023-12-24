


git clone https://github.com/terraform-google-modules/cloud-foundation-training.git
cd cloud-foundation-training/06-Cloud-Function
gcloud services enable cloudfunctions.googleapis.com
gsutil mb gs://cft-lab-state-$(gcloud config list --format 'value(core.project)')
cp terraform.example.tfvars terraform.tfvars

sed -i "19s~.*~    bucket = \"cft-lab-state-${DEVSHELL_PROJECT_ID}\" # GCS bucket for Terraform Remote State~" backend.tf

sed -i "17s/.*/project_id = \"$DEVSHELL_PROJECT_ID\" # Insert Project ID here/" terraform.tfvars


rm main.tf

cat <<EOF > main.tf
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

module "image_processing_function" {
  source  = "terraform-google-modules/event-function/google"
  version = "~> 2.2.0"

  name                   = "lab06-cloud-function-\${var.project_id}-\${random_id.suffix.hex}"
  project_id             = module.project_iam_bindings.projects[0]
  region                 = var.region
  description            = "Process image in GCS bucket"
  entry_point            = "blur_images"
  runtime                = "python37"
  source_directory       = "\${path.module}/function_source"
  bucket_force_destroy   = true
  service_account_email  = google_service_account.image_processing_gcf_sa.email

  environment_variables = {
    BLURRED_BUCKET_NAME = google_storage_bucket.image_processed.name
  }

  event_trigger = {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.image_upload.name
  }
}
EOF


terraform init -upgrade

terraform plan -out=plan.out

terraform apply plan.out

sleep 20

gsutil cp images/zombie.jpg gs://lab06-image-upload*/

