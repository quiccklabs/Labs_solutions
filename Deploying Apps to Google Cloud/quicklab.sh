

gcloud auth list

mkdir gcp-course

cd gcp-course

git clone https://GitHub.com/GoogleCloudPlatform/training-data-analyst.git

cd training-data-analyst/courses/design-process/deploying-apps-to-gcp

docker build -t test-python .


cat > app.yaml <<EOF_END
runtime: python39
EOF_END

gcloud app create --region=$REGION

gcloud app deploy --version=one --quiet

sed -i '8c\    model = {"title": "Hello App Engine"}' main.py


gcloud app deploy --version=two --no-promote --quiet

gcloud app services set-traffic default --splits=two=1 --quiet



gcloud beta container --project "$DEVSHELL_PROJECT_ID" clusters create-auto "autopilot-cluster-1" --region "us-central1" --release-channel "regular" --network "projects/$DEVSHELL_PROJECT_ID/global/networks/default" --subnetwork "projects/$DEVSHELL_PROJECT_ID/regions/us-central1/subnetworks/default" --cluster-ipv4-cidr "/17" --binauthz-evaluation-mode=DISABLED

gcloud container clusters get-credentials autopilot-cluster-1 --region us-central1 --project $DEVSHELL_PROJECT_ID

kubectl get nodes

sed -i '8c\    model = {"title": "Hello Kubernetes Engine"}' main.py


cat > kubernetes-config.yaml <<EOF_END
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devops-deployment
  labels:
    app: devops
    tier: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: devops
      tier: frontend
  template:
    metadata:
      labels:
        app: devops
        tier: frontend
    spec:
      containers:
      - name: devops-demo
        image: <YOUR IMAGE PATH HERE>
        ports:
        - containerPort: 8080

---
apiVersion: v1
kind: Service
metadata:
  name: devops-deployment-lb
  labels:
    app: devops
    tier: frontend-lb
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: devops
    tier: frontend
EOF_END


gcloud artifacts repositories create devops-demo \
    --repository-format=docker \
    --location=us-central1

gcloud auth configure-docker us-central1-docker.pkg.dev

cd ~/gcp-course/training-data-analyst/courses/design-process/deploying-apps-to-gcp
gcloud builds submit --tag us-central1-docker.pkg.dev/$DEVSHELL_PROJECT_ID/devops-demo/devops-image:v0.2 .



sed -i "23c\        image: us-central1-docker.pkg.dev/$DEVSHELL_PROJECT_ID/devops-demo/devops-image:v0.2" kubernetes-config.yaml


kubectl apply -f kubernetes-config.yaml

kubectl get pods

kubectl get services


sed -i '8c\    model = {"title": "Hello Cloud Run"}' main.py


cd ~/gcp-course/training-data-analyst/courses/design-process/deploying-apps-to-gcp
gcloud builds submit --tag us-central1-docker.pkg.dev/$DEVSHELL_PROJECT_ID/devops-demo/cloud-run-image:v0.1 .


sleep 30

# Store the output of the command in a variable
image_digest=$(gcloud container images list-tags us-central1-docker.pkg.dev/$DEVSHELL_PROJECT_ID/devops-demo/cloud-run-image --format='get(digest)' --limit=10)




echo "y" | gcloud run deploy hello-cloud-run \
--image=us-central1-docker.pkg.dev/$DEVSHELL_PROJECT_ID/devops-demo/cloud-run-image@$image_digest \
--allow-unauthenticated \
--port=8080 \
--max-instances=6 \
--cpu-boost \
--region=us-central1 \
--project=$DEVSHELL_PROJECT_ID
