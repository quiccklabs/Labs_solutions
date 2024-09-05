


export REGION=$(gcloud container clusters list --format='value(LOCATION)')

gcloud container clusters get-credentials day2-ops --region $REGION

git clone https://github.com/GoogleCloudPlatform/microservices-demo.git

cd microservices-demo

kubectl apply -f release/kubernetes-manifests.yaml

sleep 60

export EXTERNAL_IP=$(kubectl get service frontend-external -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
echo $EXTERNAL_IP

curl -o /dev/null -s -w "%{http_code}\n"  http://${EXTERNAL_IP}


gcloud logging buckets update _Default \
    --location=global \
    --enable-analytics




gcloud logging sinks create day2ops-sink \
    logging.googleapis.com/projects/$DEVSHELL_PROJECT_ID/locations/global/buckets/day2ops-log \
    --log-filter='resource.type="k8s_container"' \
    --include-children \
    --format='json'

