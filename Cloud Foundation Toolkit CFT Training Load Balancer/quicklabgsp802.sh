git clone https://github.com/terraform-google-modules/cloud-foundation-training.git

cd cloud-foundation-training/05-Load-Balancer

gsutil mb gs://cft-lab-state-$(gcloud config list --format 'value(core.project)')

cp terraform.example.tfvars terraform.tfvars

sed -i "19s~.*~    bucket = \"cft-lab-state-${DEVSHELL_PROJECT_ID}\" # GCS bucket for Terraform Remote State~" backend.tf

sed -i "17s/.*/project_id = \"$DEVSHELL_PROJECT_ID\" # Insert Project ID here/" terraform.tfvars


cat > main.tf <<EOF_END
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

module "load_balancer" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 6.2.0"
  project = module.project_iam_bindings.projects[0]
  name    = "lab05-http-load-balancer"

  backends = {
    default = {
      port_name                     = "http"
      protocol                      = "HTTP"
      port                          = 80
      description                   = null
      timeout_sec                   = null
      affinity_cookie_ttl_sec       = null
      connection_draining_timeout_sec = null
      custom_request_headers        = null
      custom_response_headers       = null
      enable_cdn                    = null
      groups                        = []  # Initialize as an empty list or with actual group values
      health_check                  = {
        request_path           = "/"
        port                   = 80
        check_interval_sec     = null
        timeout_sec            = null
        healthy_threshold      = null
        unhealthy_threshold    = null
        host                   = null
        logging                = null
      }
      iap_config                    = {
        enable                 = false
        oauth2_client_id       = ""
        oauth2_client_secret   = ""
      }
      log_config                    = {
        enable                 = false
        sample_rate            = null
      }
      security_policy               = null
      session_affinity              = null
      # Add other backend service configurations as needed
    }
  }
}

EOF_END


terraform init

terraform plan -out=plan.out

terraform apply plan.out
