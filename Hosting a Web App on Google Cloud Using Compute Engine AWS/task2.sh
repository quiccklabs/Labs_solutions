



cd ~/monolith-to-microservices/react-app/

gcloud compute forwarding-rules list --global


export EXTERNAL_IP_FANCY=$(gcloud compute instances describe fancy-http-rule --zone=$ZONE --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

cd monolith-to-microservices/react-app

cat > .env <<EOF
REACT_APP_ORDERS_URL=http://$EXTERNAL_IP_BACKEND:8081/api/orders
REACT_APP_PRODUCTS_URL=http://$EXTERNAL_IP_BACKEND:8082/api/products

REACT_APP_ORDERS_URL=http://$EXTERNAL_IP_FANCY/api/orders
REACT_APP_PRODUCTS_URL=http://$EXTERNAL_IP_FANCY/api/products
EOF

cd ~


cd ~/monolith-to-microservices/react-app
npm install && npm run-script build

cd ~
rm -rf monolith-to-microservices/*/node_modules
gsutil -m cp -r monolith-to-microservices gs://fancy-store-$DEVSHELL_PROJECT_ID/


gcloud compute instance-groups managed rolling-action replace fancy-fe-mig \
    --zone=$ZONE \
    --max-unavailable 100%


gcloud compute instance-groups managed set-autoscaling \
  fancy-fe-mig \
  --zone=$ZONE \
  --max-num-replicas 2 \
  --target-load-balancing-utilization 0.60


gcloud compute instance-groups managed set-autoscaling \
  fancy-be-mig \
  --zone=$ZONE \
  --max-num-replicas 2 \
  --target-load-balancing-utilization 0.60


gcloud compute backend-services update fancy-fe-frontend \
    --enable-cdn --global


gcloud compute instances set-machine-type frontend \
  --zone=$ZONE \
  --machine-type custom-4-3840

gcloud compute instance-templates create fancy-fe-new \
    --region=$REGION \
    --source-instance=frontend \
    --source-instance-zone=$ZONE

gcloud compute instance-groups managed rolling-action start-update fancy-fe-mig \
  --zone=$ZONE \
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
  --zone=$ZONE \
  --max-unavailable=100%





