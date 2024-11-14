
echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter ZONE: " ZONE

export REGION="${ZONE%-*}"

gcloud config set compute/zone $ZONE

gcloud config set compute/region $REGION


gsutil cp -r gs://spls/gsp480/gke-network-policy-demo .

cd gke-network-policy-demo

chmod -R 755 *


echo "y" | make setup-project

echo "yes" | make tf-apply


echo "export ZONE=$ZONE" > env_vars.sh

source env_vars.sh



cat > prepare_disk_1.sh <<'EOF_END'
source /tmp/env_vars.sh

sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin -y
echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" >> ~/.bashrc
source ~/.bashrc
gcloud container clusters get-credentials gke-demo-cluster --zone $ZONE
kubectl apply -f ./manifests/hello-app/

kubectl apply -f ./manifests/network-policy.yaml
kubectl delete -f ./manifests/network-policy.yaml
kubectl create -f ./manifests/network-policy-namespaced.yaml
kubectl -n hello-apps apply -f ./manifests/hello-app/hello-client.yaml
EOF_END


gcloud compute scp env_vars.sh gke-demo-bastion:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute scp prepare_disk_1.sh gke-demo-bastion:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh gke-demo-bastion --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk_1.sh"

