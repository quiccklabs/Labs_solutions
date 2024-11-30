

echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter ZONE: " ZONE



export REGION="${ZONE%-*}"

gcloud auth list 

git clone --depth=1 https://github.com/GoogleCloudPlatform/training-data-analyst

ln -s ~/training-data-analyst/courses/developingapps/v1.3/nodejs/containerengine ~/containerengine

cd ~/containerengine/start

export APP_REGION=$REGION
export REGION=$REGION
sed -i 's/us-central1/'"$REGION"'/g' prepare_environment.sh 
sed -i 's/us-central/'"$APP_REGION"'/g' prepare_environment.sh 

. prepare_environment.sh


gcloud beta container --project "$DEVSHELL_PROJECT_ID" clusters create "quiz-cluster" --zone "$ZONE" --no-enable-basic-auth --cluster-version "latest" --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" --disk-type "pd-balanced" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/cloud-platform" --num-nodes "3" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/$DEVSHELL_PROJECT_ID/global/networks/default" --subnetwork "projects/$DEVSHELL_PROJECT_ID/regions/$REGION/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --security-posture=standard --workload-vulnerability-scanning=disabled --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --binauthz-evaluation-mode=DISABLED --enable-managed-prometheus --enable-shielded-nodes --node-locations "$ZONE"


gcloud container clusters get-credentials quiz-cluster --zone "$ZONE" --project $DEVSHELL_PROJECT_ID

kubectl get pods



cat > frontend/Dockerfile <<EOF_END
FROM gcr.io/google_appengine/nodejs
RUN /usr/local/bin/install_node '>=0.12.7'
COPY . /app/
RUN npm install -g npm@8.1.3 --unsafe-perm || \
  ((if [ -f npm-debug.log ]; then \
      cat npm-debug.log; \
    fi) && false)
RUN npm update    
CMD npm start

EOF_END


cat > backend/Dockerfile <<EOF_END
FROM gcr.io/google_appengine/nodejs
RUN /usr/local/bin/install_node '>=0.12.7'
COPY . /app/
RUN npm install -g npm@8.1.3 --unsafe-perm || \
  ((if [ -f npm-debug.log ]; then \
      cat npm-debug.log; \
    fi) && false)
RUN npm update
CMD npm start
EOF_END


gcloud builds submit -t gcr.io/$DEVSHELL_PROJECT_ID/quiz-frontend ./frontend/

gcloud builds submit -t gcr.io/$DEVSHELL_PROJECT_ID/quiz-backend ./backend/



cat > frontend-deployment.yaml <<EOF_END
# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
apiVersion: apps/v1
kind: Deployment
metadata:
  name: quiz-frontend
  labels:
    app: quiz-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: quiz-app
      tier: frontend
  template:
    metadata:
      labels:
        app: quiz-app
        tier: frontend
    spec:
      containers:
      - name: quiz-frontend
        image: gcr.io/$GCLOUD_PROJECT/quiz-frontend
        imagePullPolicy: Always
        ports:
        - name: http-server
          containerPort: 8080
        env:
          - name: GCLOUD_PROJECT
            value: $GCLOUD_PROJECT
          - name: GCLOUD_BUCKET
            value: $GCLOUD_BUCKET

EOF_END



cat > backend-deployment.yaml <<EOF_END
# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
apiVersion: apps/v1
kind: Deployment
metadata:
  name: quiz-backend
  labels:
    app: quiz-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: quiz-app
      tier: backend
  template:
    metadata:
      labels:
        app: quiz-app
        tier: backend
    spec:
      containers:
      - name: quiz-backend
        image: gcr.io/$GCLOUD_PROJECT/quiz-backend
        imagePullPolicy: Always
        env:
          - name: GCLOUD_PROJECT
            value: $GCLOUD_PROJECT
          - name: GCLOUD_BUCKET
            value: $GCLOUD_BUCKET

EOF_END



kubectl create -f ./frontend-deployment.yaml

kubectl create -f ./backend-deployment.yaml

kubectl create -f ./frontend-service.yaml