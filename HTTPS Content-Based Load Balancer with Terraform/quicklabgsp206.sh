
echo ""
echo ""

read -p "Enter Group1_Region :- " group1_region
read -p "Enter Group2_Region :- " group2_region
read -p "Enter Group3_Region :- " group3_region


git clone https://github.com/terraform-google-modules/terraform-google-lb-http.git

cd ~/terraform-google-lb-http/examples/multi-backend-multi-mig-bucket-https-lb

rm -rf main.tf

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/HTTPS%20Content-Based%20Load%20Balancer%20with%20Terraform/main.tf


cat > variables.tf <<EOF_END
variable "group1_region" {
  default = "$group1_region"
}

variable "group2_region" {
  default = "$group2_region"
}

variable "group3_region" {
  default = "$group3_region"
}

variable "network_name" {
  default = "ml-bk-ml-mig-bkt-s-lb"
}

variable "project" {
  type = string
}
EOF_END


terraform init 

echo $DEVSHELL_PROJECT_ID | terraform plan 

echo $DEVSHELL_PROJECT_ID | terraform apply -auto-approve


EXTERNAL_IP=$(terraform output | grep load-balancer-ip | cut -d = -f2 | xargs echo -n)
echo http://${EXTERNAL_IP}
