

gcloud auth list

mkdir tfinfra

cd tfinfra


wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Automating%20the%20Deployment%20of%20Infrastructure%20Using%20Terraform/mynetwork.tf

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Automating%20the%20Deployment%20of%20Infrastructure%20Using%20Terraform/provider.tf

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Automating%20the%20Deployment%20of%20Infrastructure%20Using%20Terraform/terraform.tfstate

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Automating%20the%20Deployment%20of%20Infrastructure%20Using%20Terraform/variables.tf


mkdir instance

cd instance

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Automating%20the%20Deployment%20of%20Infrastructure%20Using%20Terraform/instance/main.tf

cd ..

terraform init

terraform fmt

terraform init

echo -e "mynet-us-vm\nmynetwork\n$ZONE" | terraform plan -var="instance_name=$(</dev/stdin)" -var="instance_network=$(</dev/stdin)" -var="instance_zone=$(</dev/stdin)"

echo -e "mynet-us-vm\nmynetwork\n$ZONE" | terraform apply -var="instance_name=$(</dev/stdin)" -var="instance_network=$(</dev/stdin)" -var="instance_zone=$(</dev/stdin)" --auto-approve
