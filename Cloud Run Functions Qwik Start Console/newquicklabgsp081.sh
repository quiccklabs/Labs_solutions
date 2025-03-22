


export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")


PROJECT_ID=`gcloud config get-value project`

export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

gcloud auth list


gcloud config set compute/region $REGION


gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com \
  osconfig.googleapis.com


sleep 60

mkdir ~/hello-http && cd $_
touch index.js && touch package.json

cat > index.js <<EOF
const functions = require('@google-cloud/functions-framework');

functions.http('helloWorld', (req, res) => {
  res.status(200).send('HTTP with Node.js in GCF 2nd gen!');
});
EOF

cat > package.json <<EOF
{
  "name": "nodejs-functions-gen2-codelab",
  "version": "0.0.1",
  "main": "index.js",
  "dependencies": {
    "@google-cloud/functions-framework": "^2.0.0"
  }
}
EOF





# Your existing deployment command
deploy_function() {
gcloud functions deploy nodejs-http-function \
  --gen2 \
  --runtime nodejs22 \
  --entry-point helloWorld \
  --source . \
  --region $REGION \
  --trigger-http \
  --timeout 600s \
  --max-instances 1 \
  --quiet
}

# Variables
SERVICE_NAME="nodejs-http-function"

# Loop until the Cloud Function is deployed
while true; do
  # Run the deployment command
  deploy_function

  # Check if Cloud Function is deployed
  if gcloud functions describe $SERVICE_NAME --region $REGION &> /dev/null; then
    echo "Cloud Function is deployed. Exiting the loop."
    break
  else
    echo "Waiting for Cloud Function to be deployed..."
    echo "Meantime Subscribe to Quicklab[https://www.youtube.com/@quick_lab]."
    sleep 10
  fi
done



SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$SERVICE_ACCOUNT \
  --role roles/pubsub.publisher

cd ..


#TASK 2

mkdir ~/hello-storage && cd $_
touch index.js && touch package.json


cat > index.js <<EOF
const functions = require('@google-cloud/functions-framework');

functions.cloudEvent('helloStorage', (cloudevent) => {
  console.log('Cloud Storage event with Node.js in GCF 2nd gen!');
  console.log(cloudevent);
});
EOF

cat > package.json <<EOF
{
  "name": "nodejs-functions-gen2-codelab",
  "version": "0.0.1",
  "main": "index.js",
  "dependencies": {
    "@google-cloud/functions-framework": "^2.0.0"
  }
}
EOF


BUCKET="gs://gcf-gen2-storage-$PROJECT_ID"
gsutil mb -l $REGION $BUCKET



# Your existing deployment command
deploy_function() {
gcloud functions deploy nodejs-storage-function \
  --gen2 \
  --runtime nodejs22 \
  --entry-point helloStorage \
  --source . \
  --region $REGION \
  --trigger-bucket $BUCKET \
  --trigger-location $REGION \
  --max-instances 1 \
  --quiet

}

# Variables
SERVICE_NAME="nodejs-storage-function"

# Loop until the Cloud Function is deployed
while true; do
  # Run the deployment command
  deploy_function

  # Check if Cloud Function is deployed
  if gcloud functions describe $SERVICE_NAME --region $REGION &> /dev/null; then
    echo "Cloud Function is deployed. Exiting the loop."
    break
  else
    echo "Waiting for Cloud Function to be deployed..."
    echo "Meantime Subscribe to Quicklab[https://www.youtube.com/@quick_lab]."
    sleep 10
  fi
done



echo "Hello World" > random.txt
gsutil cp random.txt $BUCKET/random.txt



#TASK 3

#o IAM & Admin > Audit Logs. 


gcloud projects get-iam-policy $PROJECT_ID > policy.yaml

cat <<EOF >> policy.yaml
auditConfigs:
- auditLogConfigs:
  - logType: DATA_READ
  - logType: DATA_WRITE
  service: compute.googleapis.com
EOF


gcloud projects set-iam-policy $PROJECT_ID policy.yaml --quiet

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
  --role roles/eventarc.eventReceiver

cd ~
git clone https://github.com/GoogleCloudPlatform/eventarc-samples.git

cd ~/eventarc-samples/gce-vm-labeler/gcf/nodejs





# Your existing deployment command
deploy_function() {
gcloud functions deploy gce-vm-labeler \
  --gen2 \
  --runtime nodejs22 \
  --entry-point labelVmCreation \
  --source . \
  --region $REGION \
  --trigger-event-filters="type=google.cloud.audit.log.v1.written,serviceName=compute.googleapis.com,methodName=beta.compute.instances.insert" \
  --trigger-location $REGION \
  --max-instances 1 \
  --quiet

}

# Variables
SERVICE_NAME="gce-vm-labeler"

# Loop until the Cloud Function is deployed
while true; do
  # Run the deployment command
  deploy_function

  # Check if Cloud Function is deployed
  if gcloud functions describe $SERVICE_NAME --region $REGION &> /dev/null; then
    echo "Cloud Function is deployed. Exiting the loop."
    break
  else
    echo "Waiting for Cloud Function to be deployed..."
    echo "Meantime Subscribe to Quicklab[https://www.youtube.com/@quick_lab]."
    sleep 10
  fi
done


# task 4

gcloud compute instances create instance-1 --project=$PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-osconfig=TRUE,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/debian-cloud/global/images/debian-12-bookworm-v20250311,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ops-agent-policy=v2-x86-template-1-4-0,goog-ec-src=vm_add-gcloud --reservation-affinity=any && printf 'agentsRule:\n  packageState: installed\n  version: latest\ninstanceFilter:\n  inclusionLabels:\n  - labels:\n      goog-ops-agent-policy: v2-x86-template-1-4-0\n' > config.yaml && gcloud compute instances ops-agents policies create goog-ops-agent-v2-x86-template-1-4-0-$ZONE --project=$PROJECT_ID --zone=$ZONE --file=config.yaml && gcloud compute resource-policies create snapshot-schedule default-schedule-1 --project=$PROJECT_ID --region=$REGION --max-retention-days=14 --on-source-disk-delete=keep-auto-snapshots --daily-schedule --start-time=09:00 && gcloud compute disks add-resource-policies instance-1 --project=$PROJECT_ID --zone=$ZONE --resource-policies=projects/$PROJECT_ID/regions/$REGION/resourcePolicies/default-schedule-1


#TASK 5
 
cd ~

mkdir ~/hello-world-colored && cd $_
touch main.py
touch requirements.txt

cat > main.py <<EOF
import os

color = os.environ.get('COLOR')

def hello_world(request):
    return f'<body style="background-color:{color}"><h1>Hello World!</h1></body>'
EOF



COLOR=orange
gcloud functions deploy hello-world-colored \
  --gen2 \
  --runtime python39 \
  --entry-point hello_world \
  --source . \
  --region $REGION \
  --trigger-http \
  --allow-unauthenticated \
  --update-env-vars COLOR=$COLOR \
  --max-instances 1


 # need to add code



 #TASK 6


 cd ~

 mkdir ~/min-instances && cd $_
touch main.go
touch go.mod 

cat > main.go <<EOF
package p

import (
        "fmt"
        "net/http"
        "time"
)

func init() {
        time.Sleep(10 * time.Second)
}

func HelloWorld(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "Slow HTTP Go in GCF 2nd gen!")
}
EOF

cat > go.mod <<EOF
module example.com/mod

go 1.21
EOF

gcloud functions deploy slow-function \
  --gen2 \
  --runtime go121 \
  --entry-point HelloWorld \
  --source . \
  --region $REGION \
  --trigger-http \
  --allow-unauthenticated \
  --max-instances 4



#TASK 7


SLOW_URL=$(gcloud functions describe slow-function --region $REGION --gen2 --format="value(serviceConfig.uri)")

gcloud functions deploy slow-concurrent-function \
  --gen2 \
  --runtime go121 \
  --entry-point HelloWorld \
  --source . \
  --region $REGION \
  --trigger-http \
  --allow-unauthenticated \
  --min-instances 1 \
  --max-instances 4 \
  --quiet



 # Extended task

# changing color

cd ~

encoded_project=$(echo "$PROJECT_ID" | sed 's/-/--/g')
encoded_region=$(echo "$REGION" | sed 's/-/--/g')

final_image_1="$REGION-docker.pkg.dev/$PROJECT_ID/gcf-artifacts/${encoded_project}__${encoded_region}__hello--world--colored:version_1"
final_image_2="$REGION-docker.pkg.dev/$PROJECT_ID/gcf-artifacts/${encoded_project}__${encoded_region}__slow--function:version_1"
final_image_3="$REGION-docker.pkg.dev/$PROJECT_ID/gcf-artifacts/${encoded_project}__${encoded_region}__slow--concurrent--function:version_1"


gcloud run deploy hello-world-colored \
--image=$final_image_1 \
--set-env-vars=COLOR=yellow,LOG_EXECUTION_ID=true \
--region=$REGION \
--project=$PROJECT_ID \
 && gcloud run services update-traffic hello-world-colored --region=$REGION --to-latest


# slow function

gcloud run deploy slow-function \
--image=$final_image_2 \
--min-instances=1 \
--max-instances=4 \
--set-env-vars=LOG_EXECUTION_ID=true \
--region=$REGION \
--project=$PROJECT_ID \
 && gcloud run services update-traffic slow-function --region=$REGION --to-latest



 # slow concurrent function


gcloud run deploy slow-concurrent-function \
--image=$final_image_3 \
--concurrency=100 \
--cpu=1 \
--max-instances=4 \
--set-env-vars=LOG_EXECUTION_ID=true \
--region=$REGION \
--project=$PROJECT_ID \
 && gcloud run services update-traffic slow-concurrent-function --region=$REGION --to-latest



echo -e "\033[1;33mhttps://console.cloud.google.com/run?deploymentType=function&project=\033[0m"





