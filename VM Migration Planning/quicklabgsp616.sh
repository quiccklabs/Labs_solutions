




export REGION="${ZONE%-*}"


gcloud auth list

terraform -v

git clone https://github.com/terraform-google-modules/cloud-foundation-training.git

cd cloud-foundation-training/other/terraform-codelab/lab-networking

cat > terraform.tfvars <<EOF
project_id="$DEVSHELL_PROJECT_ID"
EOF


gcloud iam service-accounts create terraform --display-name terraform


gcloud iam service-accounts keys create ./credentials.json --iam-account terraform@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:terraform@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role=roles/owner

gsutil mb gs://$DEVSHELL_PROJECT_ID-state-bucket


cat > backend.tf <<EOF
terraform {
  backend "gcs" {
    bucket = "$DEVSHELL_PROJECT_ID-state-bucket"       # Change this to <my project id>-state-bucket
    prefix = "terraform/lab/network"
  }
}
EOF


terraform init

rm -rf .terraform/
terraform init

terraform plan

terraform apply --auto-approve



#Task 6


rm -rf network.tf

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/VM%20Migration%20Planning/network.tf

sed -i 's/"$REGION"/"'$REGION'"/g' network.tf



terraform apply --auto-approve


sed -i '51c\    ports    = ["80", "443"] # Edit this line' firewall.tf


terraform apply --auto-approve



sed -i '25a\
# Add your new output below this line\
output "my_subnet_name" {\
  value = module.vpc.subnets_names[2]\
}' outputs.tf


terraform apply --auto-approve


gcloud compute instances create build-instance --zone=$ZONE --machine-type=e2-standard-2 --network-tier=PREMIUM --maintenance-policy=MIGRATE --image=debian-10-buster-v20221206 --image-project=debian-cloud --boot-disk-size=100GB --boot-disk-type=pd-standard --boot-disk-device-name=build-instance-1 --tags=allow-ssh


gcloud compute ssh build-instance --zone=$ZONE --quiet --command "sudo apt-get update && sudo apt-get install apache2 -y"


gcloud compute instances stop build-instance --zone=$ZONE

gcloud compute images create apache-one \
  --source-disk build-instance \
  --source-disk-zone $ZONE \
  --family my-apache-webserver

gcloud compute images describe-from-family my-apache-webserver


cd ../lab-app

cp ../lab-networking/credentials.json .
cp ../lab-networking/terraform.tfvars .




cat > backend.tf <<EOF
terraform {
  backend "gcs" {
    bucket = "$DEVSHELL_PROJECT_ID-state-bucket" # Edit this this line to match your lab-networking/networking backend.tf file
    prefix = "terraform/lab/vm"
  }
}

data "terraform_remote_state" "network" {
  backend = "gcs"

  config = {
    bucket = "$DEVSHELL_PROJECT_ID-state-bucket" # Update this too
    prefix = "terraform/lab/network"
  }
}
EOF


terraform init
terraform apply --auto-approve