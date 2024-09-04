



gcloud services enable artifactregistry.googleapis.com

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
export CLOUDSQL_SERVICE_ACCOUNT=cloudsql-service-account

gcloud iam service-accounts create $CLOUDSQL_SERVICE_ACCOUNT --project=$PROJECT_ID

gcloud projects add-iam-policy-binding $PROJECT_ID \
--member="serviceAccount:$CLOUDSQL_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
--role="roles/cloudsql.admin" 

gcloud iam service-accounts keys create $CLOUDSQL_SERVICE_ACCOUNT.json \
    --iam-account=$CLOUDSQL_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
    --project=$PROJECT_ID

gcloud container clusters create postgres-cluster \
--zone=$ZONE --num-nodes=2

kubectl create secret generic cloudsql-instance-credentials \
--from-file=credentials.json=$CLOUDSQL_SERVICE_ACCOUNT.json
    
kubectl create secret generic cloudsql-db-credentials \
--from-literal=username=postgres \
--from-literal=password=supersecret! \
--from-literal=dbname=gmemegen_db

gsutil -m cp -r gs://spls/gsp919/gmemegen .
cd gmemegen

export REGION=${ZONE%-*}
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
export REPO=gmemegen

gcloud auth configure-docker ${REGION}-docker.pkg.dev --quiet

gcloud artifacts repositories create $REPO \
    --repository-format=docker --location=$REGION

docker build -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/gmemegen/gmemegen-app:v1 .

docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/gmemegen/gmemegen-app:v1


sed -i "33c\          image: $REGION-docker.pkg.dev/$PROJECT_ID/gmemegen/gmemegen-app:v1" gmemegen_deployment.yaml

sed -i "60c\                    "-instances=$PROJECT_ID:$REGION:postgres-gmemegen=tcp:5432"," gmemegen_deployment.yaml

kubectl create -f gmemegen_deployment.yaml

kubectl get pods

sleep 20

kubectl expose deployment gmemegen \
    --type "LoadBalancer" \
    --port 80 --target-port 8080

sleep 20


export LOAD_BALANCER_IP=$(kubectl get svc gmemegen \
-o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n default)
echo gMemegen Load Balancer Ingress IP: http://$LOAD_BALANCER_IP

POD_NAME=$(kubectl get pods --output=json | jq -r ".items[0].metadata.name")
kubectl logs $POD_NAME gmemegen | grep "INFO"



INSTANCE_NAME="postgres-gmemegen"
DB_USER="postgres"
DB_NAME="gmemegen_db"

gcloud sql connect $INSTANCE_NAME --user=$DB_USER --quiet << EOF

\c $DB_NAME

SELECT * FROM meme;
EOF
