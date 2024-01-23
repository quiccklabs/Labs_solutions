

export REGION="${ZONE%-*}"

gcloud config set compute/zone $ZONE

gcloud container clusters create spinnaker-tutorial \
    --machine-type=e2-standard-2

gcloud iam service-accounts create spinnaker-account \
    --display-name spinnaker-account

export SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:spinnaker-account" \
    --format='value(email)')

export PROJECT=$(gcloud info --format='value(config.project)')

gcloud projects add-iam-policy-binding $PROJECT \
    --role roles/storage.admin \
    --member serviceAccount:$SA_EMAIL

gcloud iam service-accounts keys create spinnaker-sa.json \
     --iam-account $SA_EMAIL


gcloud pubsub topics create projects/$PROJECT/topics/gcr

gcloud pubsub subscriptions create gcr-triggers \
    --topic projects/${PROJECT}/topics/gcr


export SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:spinnaker-account" \
    --format='value(email)')

gcloud beta pubsub subscriptions add-iam-policy-binding gcr-triggers \
    --role roles/pubsub.subscriber --member serviceAccount:$SA_EMAIL

kubectl create clusterrolebinding user-admin-binding \
    --clusterrole=cluster-admin --user=$(gcloud config get-value account)

kubectl create clusterrolebinding --clusterrole=cluster-admin \
    --serviceaccount=default:default spinnaker-admin

helm repo add stable https://charts.helm.sh/stable
helm repo update

export PROJECT=$(gcloud info \
    --format='value(config.project)')

export BUCKET=$PROJECT-spinnaker-config

gsutil mb -c regional -l $REGION gs://$BUCKET

export SA_JSON=$(cat spinnaker-sa.json)
export PROJECT=$(gcloud info --format='value(config.project)')
export BUCKET=$PROJECT-spinnaker-config
cat > spinnaker-config.yaml <<EOF
gcs:
  enabled: true
  bucket: $BUCKET
  project: $PROJECT
  jsonKey: '$SA_JSON'

dockerRegistries:
- name: gcr
  address: https://gcr.io
  username: _json_key
  password: '$SA_JSON'
  email: 1234@5678.com

# Disable minio as the default storage backend
minio:
  enabled: false

# Configure Spinnaker to enable GCP services
halyard:
  spinnakerVersion: 1.19.4
  image:
    repository: us-docker.pkg.dev/spinnaker-community/docker/halyard
    tag: 1.32.0
    pullSecrets: []
  additionalScripts:
    create: true
    data:
      enable_gcs_artifacts.sh: |-
        \$HAL_COMMAND config artifact gcs account add gcs-$PROJECT --json-path /opt/gcs/key.json
        \$HAL_COMMAND config artifact gcs enable
      enable_pubsub_triggers.sh: |-
        \$HAL_COMMAND config pubsub google enable
        \$HAL_COMMAND config pubsub google subscription add gcr-triggers \
          --subscription-name gcr-triggers \
          --json-path /opt/gcs/key.json \
          --project $PROJECT \
          --message-format GCR
EOF

helm install -n default cd stable/spinnaker -f spinnaker-config.yaml \
           --version 2.0.0-rc9 --timeout 10m0s --wait

export DECK_POD=$(kubectl get pods --namespace default -l "cluster=spin-deck" \
    -o jsonpath="{.items[0].metadata.name}")


kubectl port-forward --namespace default $DECK_POD 8080:9000 >> /dev/null &



gsutil -m cp -r gs://spls/gsp114/sample-app.tar .

mkdir sample-app
tar xvf sample-app.tar -C ./sample-app

cd sample-app

git config --global user.email "$(gcloud config get-value core/account)"

git config --global user.name "$USER_EMAIL"

git init

git add .

git commit -m "Initial commit"

gcloud source repos create sample-app

git config credential.helper gcloud.sh

export PROJECT=$(gcloud info --format='value(config.project)')

git remote add origin https://source.developers.google.com/p/$PROJECT/r/sample-app

git push origin master


# Set variables
REPO_NAME=sample-app
TRIGGER_NAME=sample-app-tags

# Create the Cloud Build trigger
gcloud builds triggers create cloud-source-repositories \
  --name=$TRIGGER_NAME \
  --tag-pattern=".*" \
  --repo=$REPO_NAME \
  --project=$PROJECT \
  --build-config=cloudbuild.yaml



export PROJECT=$(gcloud info --format='value(config.project)')

gsutil mb -l $REGION gs://$PROJECT-kubernetes-manifests

gsutil versioning set on gs://$PROJECT-kubernetes-manifests

sed -i s/PROJECT/$PROJECT/g k8s/deployments/*

git commit -a -m "Set project ID"

git tag v1.0.0

git push --tags

while [[ "$BUILD" != "SUCCESS" ]]; do
  echo "Build is still in progress. Waiting..."
  echo "Mean Time Like share subscribe to Quicklab [https://www.youtube.com/@quick_lab]..." 
  sleep 10  # Adjust the sleep duration as needed
  BUILD=$(gcloud builds list --format="value(STATUS)" | grep "SUCCESS")
done

echo "Build successful. Proceeding with the next code."
# Add your next code here



sleep 120

curl -LO https://storage.googleapis.com/spinnaker-artifacts/spin/1.14.0/linux/amd64/spin

chmod +x spin

./spin application save --application-name sample \
                        --owner-email "$(gcloud config get-value core/account)" \
                        --cloud-providers kubernetes \
                        --gate-endpoint http://localhost:8080/gate


export PROJECT=$(gcloud info --format='value(config.project)')
sed s/PROJECT/$PROJECT/g spinnaker/pipeline-deploy.json > pipeline.json
./spin pipeline save --gate-endpoint http://localhost:8080/gate -f pipeline.json                        


