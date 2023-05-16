
gcloud config set compute/zone us-central1-f

gcloud services enable compute.googleapis.com

gsutil mb gs://fancy-store-$DEVSHELL_PROJECT_ID

git clone https://github.com/googlecodelabs/monolith-to-microservices.git

cd ~/monolith-to-microservices

./setup.sh

nvm install --lts


====================================================================================================================================

Open Editor 

Click on File > New File and create a file called startup-script.sh

====================================================================================================================================



gsutil cp ~/monolith-to-microservices/startup-script.sh gs://fancy-store-$DEVSHELL_PROJECT_ID

cd ~
rm -rf monolith-to-microservices/*/node_modules
gsutil -m cp -r monolith-to-microservices gs://fancy-store-$DEVSHELL_PROJECT_ID/


gcloud compute instances create backend \
    --machine-type=n1-standard-1 \
    --tags=backend \
   --metadata=startup-script-url=https://storage.googleapis.com/fancy-store-$DEVSHELL_PROJECT_ID/startup-script.sh

gcloud compute instances list




======================================================================================================================================================================================================


In the Cloud Shell Explorer, navigate to monolith-to-microservices > react-app.

In the Code Editor, select View > Toggle Hidden Files in order to see the .env file.

====================================================================================================================================


cd ~/monolith-to-microservices/react-app
npm install && npm run-script build

cd ~
rm -rf monolith-to-microservices/*/node_modules

gsutil -m cp -r monolith-to-microservices gs://fancy-store-$DEVSHELL_PROJECT_ID/

gcloud compute instances create frontend \
    --machine-type=n1-standard-1 \
    --tags=frontend \
    --metadata=startup-script-url=https://storage.googleapis.com/fancy-store-$DEVSHELL_PROJECT_ID/startup-script.sh


gcloud compute firewall-rules create fw-fe \
    --allow tcp:8080 \
    --target-tags=frontend

gcloud compute firewall-rules create fw-be \
    --allow tcp:8081-8082 \
    --target-tags=backend

gcloud compute instances list

gcloud compute instances stop frontend

gcloud compute instances stop backend

gcloud compute instance-templates create fancy-fe \
    --source-instance=frontend

gcloud compute instance-templates create fancy-be \
    --source-instance=backend

gcloud compute instance-templates list

gcloud compute instances delete --quiet  backend

gcloud compute instance-groups managed create fancy-fe-mig \
    --base-instance-name fancy-fe \
    --size 2 \
    --template fancy-fe

gcloud compute instance-groups managed create fancy-be-mig \
    --base-instance-name fancy-be \
    --size 2 \
    --template fancy-be

gcloud compute instance-groups set-named-ports fancy-fe-mig \
    --named-ports frontend:8080

gcloud compute instance-groups set-named-ports fancy-be-mig \
    --named-ports orders:8081,products:8082

gcloud compute health-checks create http fancy-fe-hc \
    --port 8080 \
    --check-interval 30s \
    --healthy-threshold 1 \
    --timeout 10s \
    --unhealthy-threshold 3

gcloud compute health-checks create http fancy-be-hc \
    --port 8081 \
    --request-path=/api/orders \
    --check-interval 30s \
    --healthy-threshold 1 \
    --timeout 10s \
    --unhealthy-threshold 3

gcloud compute firewall-rules create allow-health-check \
    --allow tcp:8080-8081 \
    --source-ranges 130.211.0.0/22,35.191.0.0/16 \
    --network default

gcloud compute instance-groups managed update fancy-fe-mig \
    --health-check fancy-fe-hc \
    --initial-delay 300

gcloud compute instance-groups managed update fancy-be-mig \
    --health-check fancy-be-hc \
    --initial-delay 300

gcloud compute http-health-checks create fancy-fe-frontend-hc \
  --request-path / \
  --port 8080

gcloud compute http-health-checks create fancy-be-orders-hc \
  --request-path /api/orders \
  --port 8081

gcloud compute http-health-checks create fancy-be-products-hc \
  --request-path /api/products \
  --port 8082

gcloud compute backend-services create fancy-fe-frontend \
  --http-health-checks fancy-fe-frontend-hc \
  --port-name frontend \
  --global

gcloud compute backend-services create fancy-be-orders \
  --http-health-checks fancy-be-orders-hc \
  --port-name orders \
  --global

gcloud compute backend-services create fancy-be-products \
  --http-health-checks fancy-be-products-hc \
  --port-name products \
  --global

gcloud compute backend-services add-backend fancy-fe-frontend \
  --instance-group fancy-fe-mig \
  --instance-group-zone us-central1-f \
  --global

gcloud compute backend-services add-backend fancy-be-orders \
  --instance-group fancy-be-mig \
  --instance-group-zone us-central1-f \
  --global

gcloud compute backend-services add-backend fancy-be-products \
  --instance-group fancy-be-mig \
  --instance-group-zone us-central1-f \
  --global

gcloud compute url-maps create fancy-map \
  --default-service fancy-fe-frontend

gcloud compute url-maps add-path-matcher fancy-map \
   --default-service fancy-fe-frontend \
   --path-matcher-name orders \
   --path-rules "/api/orders=fancy-be-orders,/api/products=fancy-be-products"


gcloud compute target-http-proxies create fancy-proxy \
  --url-map fancy-map

gcloud compute forwarding-rules create fancy-http-rule \
  --global \
  --target-http-proxy fancy-proxy \
  --ports 80

cd ~/monolith-to-microservices/react-app/

gcloud compute forwarding-rules list --global




====================================================================================================================================


Return to the Cloud Shell Editor


REACT_APP_ORDERS_URL=http://[LB_IP]/api/orders

REACT_APP_PRODUCTS_URL=http://[LB_IP]/api/products


====================================================================================================================================


cd ~/monolith-to-microservices/react-app
npm install && npm run-script build

cd ~
rm -rf monolith-to-microservices/*/node_modules
gsutil -m cp -r monolith-to-microservices gs://fancy-store-$DEVSHELL_PROJECT_ID/


gcloud compute instance-groups managed rolling-action replace fancy-fe-mig \
    --max-unavailable 100%


gcloud compute instance-groups managed set-autoscaling \
  fancy-fe-mig \
  --max-num-replicas 2 \
  --target-load-balancing-utilization 0.60


gcloud compute instance-groups managed set-autoscaling \
  fancy-be-mig \
  --max-num-replicas 2 \
  --target-load-balancing-utilization 0.60


gcloud compute backend-services update fancy-fe-frontend \
    --enable-cdn --global


gcloud compute instances set-machine-type frontend --machine-type custom-4-3840

gcloud compute instance-templates create fancy-fe-new \
    --source-instance=frontend \
    --source-instance-zone=us-central1-f

gcloud compute instance-groups managed rolling-action start-update fancy-fe-mig \
    --version template=fancy-fe-new


cd ~/monolith-to-microservices/react-app/src/pages/Home
mv index.js.new index.js


cat ~/monolith-to-microservices/react-app/src/pages/Home/index.js


cd ~/monolith-to-microservices/react-app
npm install && npm run-script build


cd ~
rm -rf monolith-to-microservices/*/node_modules
gsutil -m cp -r monolith-to-microservices gs://fancy-store-$DEVSHELL_PROJECT_ID/


gcloud compute instance-groups managed rolling-action replace fancy-fe-mig \
    --max-unavailable=100%









