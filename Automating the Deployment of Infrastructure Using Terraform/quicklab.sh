

read -p "Enter ZONE 1:- " ZONE_1
read -p "Enter ZONE 2:- " ZONE_2

# wget command



wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Automating%20the%20Deployment%20of%20Infrastructure%20Using%20Terraform/mynetwork.tf

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Automating%20the%20Deployment%20of%20Infrastructure%20Using%20Terraform/provider.tf


sed -i "s/instance_zone    = \"\$ZONE\"/instance_zone    = \"$ZONE_1\"/g" mynetwork.tf
sed -i "s/instance_zone    = \"\$ZONE_2\"/instance_zone    = \"$ZONE_2\"/g" mynetwork.tf

mkdir instance

cd instance

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Automating%20the%20Deployment%20of%20Infrastructure%20Using%20Terraform/instance/main.tf

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/refs/heads/master/Automating%20the%20Deployment%20of%20Infrastructure%20Using%20Terraform/instance/variables.tf




cd ..

terraform init

terraform fmt

terraform init

terraform plan

terraform apply --auto-approve



