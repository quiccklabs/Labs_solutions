
#!/bin/bash

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)



#!/bin/bash

# Set GCP region and zone
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# Define instance and cluster variables
INSTANCE_NAME="gke-tutorial-admin"

CLUSTER_NAME="rbac-demo-cluster"
RBAC_MANIFEST_PATH="./manifests/rbac.yaml"

# SSH and run commands remotely on the instance
gcloud compute ssh $INSTANCE_NAME --zone $ZONE --quiet --command "
  sudo apt-get update &&
  sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin &&
  echo 'source ~/.bashrc' >> ~/.bash_profile &&
  source ~/.bash_profile &&
  gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE &&
  kubectl apply -f $RBAC_MANIFEST_PATH
"

INSTANCE_NAME2=gke-tutorial-owner

# Define instance and cluster variables
# SSH and run commands remotely on the instance
gcloud compute ssh $INSTANCE_NAME2 --zone $ZONE --command '
  sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin &&
  echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" >> ~/.bashrc &&
  source ~/.bashrc &&
  gcloud container clusters get-credentials '"$CLUSTER_NAME"' --zone '"$ZONE"' &&
  kubectl create -n dev -f ./manifests/hello-server.yaml &&
  kubectl create -n prod -f ./manifests/hello-server.yaml &&
  kubectl create -n test -f ./manifests/hello-server.yaml
'

#TASk 3

gcloud compute ssh $INSTANCE_NAME --zone $ZONE --command "kubectl apply -f manifests/pod-labeler.yaml"

gcloud compute ssh "$INSTANCE_NAME" --zone "$ZONE" --command '

kubectl get pod -o yaml -l app=pod-labeler &&
kubectl apply -f manifests/pod-labeler-fix-1.yaml &&
kubectl get deployment pod-labeler -o yaml &&
kubectl get pods -l app=pod-labeler &&
kubectl logs -l app=pod-labeler &&
kubectl get rolebinding pod-labeler -o yaml &&
kubectl get role pod-labeler -o yaml &&
kubectl get rolebinding pod-labeler -oyaml &&
kubectl get role pod-labeler -oyaml &&
kubectl apply -f manifests/pod-labeler-fix-2.yaml
'


gcloud compute ssh "$INSTANCE_NAME" --zone "$ZONE" --command '
kubectl get rolebinding pod-labeler -oyaml &&
kubectl get role pod-labeler -oyaml &&
kubectl apply -f manifests/pod-labeler-fix-2.yaml
'
