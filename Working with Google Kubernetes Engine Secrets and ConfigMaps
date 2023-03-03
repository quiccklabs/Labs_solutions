TASK 1:-

export my_zone=us-central1-a
export my_cluster=standard-cluster-1

source <(kubectl completion bash)

export my_service_account=[MY-SERVICE-ACCOUNT-EMAIL]

gcloud container clusters create $my_cluster \
  --num-nodes 2 --zone $my_zone \
  --service-account=$my_service_account

gcloud container clusters get-credentials $my_cluster --zone $my_zone

export my_pubsub_topic=echo
export my_pubsub_subscription=echo-read

gcloud pubsub topics create $my_pubsub_topic
gcloud pubsub subscriptions create $my_pubsub_subscription \
 --topic=$my_pubsub_topic

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s

cd ~/ak8s/Secrets/

kubectl apply -f pubsub.yaml


//Create service account credentials for lab instruction



ls ~/

kubectl create secret generic pubsub-key \
 --from-file=key.json=$HOME/credentials.json


kubectl apply -f pubsub-secret.yaml



Task 2:- 


kubectl create configmap sample --from-literal=message=hello

kubectl create configmap sample2 --from-file=sample2.properties

kubectl apply -f config-map-3.yaml

kubectl apply -f pubsub-configmap.yaml

kubectl apply -f pubsub-configmap2.yaml













