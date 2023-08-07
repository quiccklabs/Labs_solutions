


REGION="${ZONE%-*}"


gcloud beta container --project "$DEVSHELL_PROJECT_ID" clusters create "echo-cluster" --zone "$ZONE" --no-enable-basic-auth --cluster-version "latest" --release-channel "regular" --machine-type "e2-standard-2" --image-type "COS_CONTAINERD" --disk-type "pd-balanced" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/$DEVSHELL_PROJECT_ID/global/networks/default" --subnetwork "projects/$DEVSHELL_PROJECT_ID/regions/$REGION/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --security-posture=standard --workload-vulnerability-scanning=disabled --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-managed-prometheus --enable-shielded-nodes --node-locations "$ZONE"


export PROJECT_ID=$(gcloud info --format='value(config.project)')

gsutil cp gs://${PROJECT_ID}/echo-web.tar.gz .

tar -xvzf echo-web.tar.gz

cd echo-web

docker build -t echo-app:v1 .

docker tag echo-app:v1 gcr.io/${PROJECT_ID}/echo-app:v1

docker push gcr.io/${PROJECT_ID}/echo-app:v1

kubectl create deployment echo-app --image=gcr.io/${PROJECT_ID}/echo-app:v1


gcloud container clusters get-credentials echo-cluster --zone=$ZONE

kubectl run echo-app --image=gcr.io/${PROJECT_ID}/echo-app:v1 --port 8000


kubectl expose deployment echo-app --name echo-web \
   --type LoadBalancer --port 80 --target-port 8000

kubectl get service echo-web











