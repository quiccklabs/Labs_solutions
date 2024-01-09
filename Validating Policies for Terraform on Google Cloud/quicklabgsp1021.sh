gcloud auth list

git clone https://github.com/GoogleCloudPlatform/policy-library.git

cd policy-library/
cp samples/iam_service_accounts_only.yaml policies/constraints

cat policies/constraints/iam_service_accounts_only.yaml

cat > main.tf <<EOF_END
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 3.84"
    }
  }
}

resource "google_project_iam_binding" "sample_iam_binding" {
  project = "$DEVSHELL_PROJECT_ID"
  role    = "roles/viewer"

  members = [
    "user:$USER_EMAIL"
  ]
}
EOF_END

terraform init

terraform plan -out=test.tfplan

terraform show -json ./test.tfplan > ./tfplan.json

sudo apt-get install google-cloud-sdk-terraform-tools

gcloud beta terraform vet tfplan.json --policy-library=.


cd policies/constraints


cat > iam_service_accounts_only.yaml <<EOF_END
apiVersion: constraints.gatekeeper.sh/v1alpha1
kind: GCPIAMAllowedPolicyMemberDomainsConstraintV1
metadata:
  name: service_accounts_only
spec:
  severity: high
  match:
    target: ["organizations/**"]
  parameters:
    domains:
      - gserviceaccount.com
      - qwiklabs.net
EOF_END


cd ~

cd policy-library

terraform plan -out=test.tfplan

gcloud beta terraform vet tfplan.json --policy-library=.

terraform apply test.tfplan

terraform plan -out=test.tfplan

gcloud beta terraform vet tfplan.json --policy-library=.

terraform apply test.tfplan