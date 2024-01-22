


gcloud auth list


gcloud config set compute/zone $ZONE

git clone https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes.git

cd continuous-deployment-on-kubernetes

gcloud container clusters create jenkins-cd \
--num-nodes 2 \
--scopes "https://www.googleapis.com/auth/projecthosting,cloud-platform"

gcloud container clusters get-credentials jenkins-cd

helm repo add jenkins https://charts.jenkins.io

helm repo update

helm upgrade --install -f jenkins/values.yaml myjenkins jenkins/jenkins
