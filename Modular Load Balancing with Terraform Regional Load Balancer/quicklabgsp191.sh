

gcloud auth list

git clone https://github.com/GoogleCloudPlatform/terraform-google-lb
cd ~/terraform-google-lb/examples/basic

export GOOGLE_PROJECT=$(gcloud config get-value project)


sed -i 's/us-central1/'"$REGION"'/g' variables.tf


export TF_VAR_project_id=$DEVSHELL_PROJECT_ID

terraform init
terraform plan
yes | terraform apply --auto-approve

