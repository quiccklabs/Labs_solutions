
gcloud auth list

git clone https://github.com/GoogleCloudPlatform/terraform-google-lb-http.git

cd ~/terraform-google-lb-http/examples/multi-backend-multi-mig-bucket-https-lb

rm -rf main.tf

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/HTTPS%20Content-Based%20Load%20Balancer%20with%20Terraform/main.tf


terraform init 

echo $DEVSHELL_PROJECT_ID | terraform plan 

echo $DEVSHELL_PROJECT_ID | terraform apply -auto-approve


EXTERNAL_IP=$(terraform output | grep load-balancer-ip | cut -d = -f2 | xargs echo -n)
echo http://${EXTERNAL_IP}