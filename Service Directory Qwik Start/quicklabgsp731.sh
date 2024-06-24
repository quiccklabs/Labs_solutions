



gcloud services enable networkservices.googleapis.com

gcloud services enable servicedirectory.googleapis.com

gcloud service-directory namespaces create example-namespace --location=$REGION

gcloud service-directory services create example-service --namespace=example-namespace --location=$REGION

gcloud service-directory endpoints create example-endpoint \
    --namespace=example-namespace \
    --service=example-service \
    --address=0.0.0.0 \
    --port=80 \
    --location=$REGION


gcloud dns --project=$DEVSHELL_PROJECT_ID managed-zones create example-zone-name --description="" --dns-name="myzone.example.com." --visibility="private" --networks="https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/networks/default" --service-directory-namespace="https://servicedirectory.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/$REGION/namespaces/example-namespace"



