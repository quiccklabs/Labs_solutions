
echo ""
echo ""

read -p "ENTER ZONE: " ZONE

export REGION="${ZONE%-*}"


gcloud auth list

gcloud config set compute/zone $ZONE

gcloud config set compute/region $REGION

cat << EOF > startup.sh
#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF

gcloud compute instance-templates create nginx-template \
         --metadata-from-file startup-script=startup.sh

gcloud compute target-pools create nginx-pool

gcloud compute instance-groups managed create nginx-group \
         --base-instance-name nginx \
         --size 2 \
         --template nginx-template \
         --target-pool nginx-pool

gcloud compute firewall-rules create www-firewall --allow tcp:80


gcloud compute forwarding-rules create nginx-lb \
         --region $REGION \
         --ports=80 \
         --target-pool nginx-pool

gcloud compute http-health-checks create http-basic-check

gcloud compute instance-groups managed \
       set-named-ports nginx-group \
       --named-ports http:80

gcloud compute backend-services create nginx-backend \
      --protocol HTTP --http-health-checks http-basic-check --global

gcloud compute backend-services add-backend nginx-backend \
    --instance-group nginx-group \
    --instance-group-zone $ZONE \
    --global

gcloud compute url-maps create web-map \
    --default-service nginx-backend

gcloud compute target-http-proxies create http-lb-proxy \
    --url-map web-map


gcloud compute forwarding-rules create http-content-rule \
        --global \
        --target-http-proxy http-lb-proxy \
        --ports 80
