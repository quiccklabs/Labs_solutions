

gcloud auth list 

git clone https://github.com/GoogleCloudPlatform/gke-tracing-demo
cd gke-tracing-demo/terraform

rm provider.tf

cat > provider.tf <<EOF_END
provider "google" {
  project = var.project
}
EOF_END

terraform init

../scripts/generate-tfvars.sh


terraform plan -var="project=$DEVSHELL_PROJECT_ID" -var="zone=$ZONE"


cat > terraform.tfvars <<EOF_END
project = $DEVSHELL_PROJECT_ID
zone    = $ZONE
EOF_END

terraform apply -var="project=$DEVSHELL_PROJECT_ID" -var="zone=$ZONE" -auto-approve

kubectl apply -f tracing-demo-deployment.yaml

sleep 30

echo http://$(kubectl get svc tracing-demo -n default -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

sleep 60

echo http://$(kubectl get svc tracing-demo -n default -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
