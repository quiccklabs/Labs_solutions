

#!/bin/bash

ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])" 2>/dev/null)
if [ -z "$ZONE" ]; then
  while [ -z "$ZONE" ]; do
    read -p "Please enter the ZONE: " ZONE
  done
fi
export ZONE

REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])" 2>/dev/null)
if [ -z "$REGION" ]; then
  if [ -n "$ZONE" ]; then
    REGION="${ZONE%-*}"
  fi
fi
if [ -z "$REGION" ]; then
  while [ -z "$REGION" ]; do
    read -p "Please enter the REGION: " REGION
  done
fi
export REGION

export PROJECT_ID=$(gcloud config get-value project)

gcloud config set compute/region $REGION

gcloud services enable \
  container.googleapis.com \
  clouddeploy.googleapis.com \
  artifactregistry.googleapis.com \
  cloudbuild.googleapis.com \
  clouddeploy.googleapis.com

for i in $(seq 30 -1 1); do sleep 1; done

gcloud container clusters create test --node-locations=$ZONE --num-nodes=1  --async
gcloud container clusters create staging --node-locations=$ZONE --num-nodes=1  --async
gcloud container clusters create prod --node-locations=$ZONE --num-nodes=1  --async

gcloud artifacts repositories create web-app \
  --description="Image registry for tutorial web app" \
  --repository-format=docker \
  --location=$REGION

cd ~/
git clone https://github.com/GoogleCloudPlatform/cloud-deploy-tutorials.git
cd cloud-deploy-tutorials
git checkout c3cae80 --quiet
cd tutorials/base

envsubst < clouddeploy-config/skaffold.yaml.template > web/skaffold.yaml
sed -i "s/{{project-id}}/$PROJECT_ID/g" web/skaffold.yaml

if ! gsutil ls "gs://${PROJECT_ID}_cloudbuild/" &>/dev/null; then
  gsutil mb -p "${PROJECT_ID}" -l "${REGION}" -b on "gs://${PROJECT_ID}_cloudbuild/"
  sleep 5
fi

cd web
skaffold build --interactive=false \
  --default-repo $REGION-docker.pkg.dev/$PROJECT_ID/web-app \
  --file-output artifacts.json
cd ..

gcloud artifacts docker images list \
  $REGION-docker.pkg.dev/$PROJECT_ID/web-app \
  --include-tags \
  --format yaml

gcloud config set deploy/region $REGION

cp clouddeploy-config/delivery-pipeline.yaml.template clouddeploy-config/delivery-pipeline.yaml
gcloud beta deploy apply --file=clouddeploy-config/delivery-pipeline.yaml

gcloud beta deploy delivery-pipelines describe web-app

while true; do
  cluster_statuses=$(gcloud container clusters list --format="csv(name,status)" | tail -n +2)
  all_running=true
  if [ -z "$cluster_statuses" ]; then
    all_running=false
  else
    echo "$cluster_statuses" | while IFS=, read -r cluster_name cluster_status; do
      cluster_name_trimmed=$(echo "$cluster_name" | tr -d '[:space:]')
      cluster_status_trimmed=$(echo "$cluster_status" | tr -d '[:space:]')
      if [ -z "$cluster_name_trimmed" ]; then continue; fi
      if [[ "$cluster_status_trimmed" != "RUNNING" ]]; then
        all_running=false
      fi
    done
  fi
  if [ "$all_running" = true ] && [ -n "$cluster_statuses" ]; then
    break 
  fi
  for i in $(seq 10 -1 1); do sleep 1; done
done 

CONTEXTS=("test" "staging" "prod")
for CONTEXT in ${CONTEXTS[@]}; do
  gcloud container clusters get-credentials ${CONTEXT} --region ${REGION}
  kubectl config rename-context gke_${PROJECT_ID}_${REGION}_${CONTEXT} ${CONTEXT}
done

for CONTEXT_NAME in ${CONTEXTS[@]}; do
  MAX_RETRIES=20
  RETRY_COUNT=0
  SUCCESS=false
  while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if kubectl --context ${CONTEXT_NAME} apply -f kubernetes-config/web-app-namespace.yaml; then
      SUCCESS=true
      break
    else
      RETRY_COUNT=$((RETRY_COUNT+1))
      sleep 5
    fi
  done
done

for CONTEXT in ${CONTEXTS[@]}; do
  envsubst < clouddeploy-config/target-$CONTEXT.yaml.template > clouddeploy-config/target-$CONTEXT.yaml
  gcloud beta deploy apply --file=clouddeploy-config/target-$CONTEXT.yaml --region=${REGION} --project=${PROJECT_ID}
done

gcloud beta deploy releases create web-app-001 \
  --delivery-pipeline web-app \
  --build-artifacts web/artifacts.json \
  --source web/ \
  --project=${PROJECT_ID} \
  --region=${REGION}

while true; do
  status=$(gcloud beta deploy rollouts list --delivery-pipeline web-app --release web-app-001 --filter="targetId=test" --format="value(state)" | head -n 1)
  if [ "$status" == "SUCCEEDED" ]; then break; fi
  if [[ "$status" == "FAILED" || "$status" == "CANCELLED" || "$status" == "HALTED" ]]; then break; fi
  sleep 10
done

kubectx test
kubectl get all -n web-app

gcloud beta deploy releases promote \
  --delivery-pipeline web-app \
  --release web-app-001 \
  --quiet

while true; do
  status=$(gcloud beta deploy rollouts list --delivery-pipeline web-app --release web-app-001 --filter="targetId=staging" --format="value(state)" | head -n 1)
  if [ "$status" == "SUCCEEDED" ]; then break; fi
  if [[ "$status" == "FAILED" || "$status" == "CANCELLED" || "$status" == "HALTED" ]]; then break; fi
  sleep 10
done

gcloud beta deploy releases promote \
  --delivery-pipeline web-app \
  --release web-app-001 \
  --quiet

while true; do
  status=$(gcloud beta deploy rollouts list --delivery-pipeline web-app --release web-app-001 --filter="targetId=prod" --format="value(state)" | head -n 1)
  if [ "$status" == "PENDING_APPROVAL" ]; then break; fi
  if [[ "$status" == "FAILED" || "$status" == "CANCELLED" || "$status" == "HALTED" || "$status" == "SUCCEEDED" ]]; then break; fi
  sleep 10
done

prod_rollout_name=$(gcloud beta deploy rollouts list \
  --delivery-pipeline web-app \
  --release web-app-001 \
  --filter="targetId=prod AND state=PENDING_APPROVAL" \
  --format="value(name)" | head -n 1)

gcloud beta deploy rollouts approve "$prod_rollout_name" \
  --delivery-pipeline web-app \
  --release web-app-001 \
  --quiet

while true; do
  status=$(gcloud beta deploy rollouts list --delivery-pipeline web-app --release web-app-001 --filter="targetId=prod" --format="value(state)" | head -n 1)
  if [ "$status" == "SUCCEEDED" ]; then break; fi
  if [[ "$status" == "FAILED" || "$status" == "CANCELLED" || "$status" == "HALTED" ]]; then break; fi
  sleep 10
done

kubectx prod
kubectl get all -n web-app
