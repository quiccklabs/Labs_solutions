


gcloud config set compute/zone $ZONE

gcloud container clusters create hello-world

git clone https://github.com/GoogleCloudPlatform/kubernetes-engine-samples

cd kubernetes-engine-samples/quickstarts/hello-app

docker build -t gcr.io/$DEVSHELL_PROJECT_ID/hello-app:1.0 .

gcloud docker -- push gcr.io/$DEVSHELL_PROJECT_ID/hello-app:1.0

kubectl create deployment hello-app --image=gcr.io/$DEVSHELL_PROJECT_ID/hello-app:1.0

kubectl expose deployment hello-app --name=hello-app --type=LoadBalancer --port=80 --target-port=8080