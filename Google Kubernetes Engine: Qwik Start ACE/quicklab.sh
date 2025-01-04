echo ""
echo ""

read -p "ENTER ZONE: " ZONE

gcloud config set compute/zone $ZONE

gcloud container clusters create --machine-type=e2-medium --zone=$ZONE lab-cluster

gcloud container clusters get-credentials lab-cluster

kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0

kubectl expose deployment hello-server --type=LoadBalancer --port 8080
