


export ZONE=$(gcloud compute instances list --project="$DEVSHELL_PROJECT_ID" --format="value(zone)" | head -n 1)


export REGION="${ZONE%-*}"


# Enable Serverless VPC Access
gcloud services enable vpcaccess.googleapis.com --project=$DEVSHELL_PROJECT_ID

# Create VPC Network Peering
gcloud services enable servicenetworking.googleapis.com --project=$DEVSHELL_PROJECT_ID

gcloud compute addresses create google-managed-services-default \
  --global \
  --purpose=VPC_PEERING \
  --prefix-length=16 \
  --description="peering range for Google-managed services" \
  --network=default \
  --project=$DEVSHELL_PROJECT_ID

gcloud services vpc-peerings connect \
  --service=servicenetworking.googleapis.com \
  --ranges=google-managed-services-default \
  --network=default \
  --project=$DEVSHELL_PROJECT_ID


gcloud beta sql instances create wordpress-db \
  --region=$REGION \
  --database-version=MYSQL_5_7 \
  --root-password=subscribe_to_quicklab \
  --tier=db-n1-standard-1 \
  --storage-type=SSD \
  --storage-size=10GB \
  --network=default \
  --no-assign-ip \
  --enable-google-private-path \
  --authorized-networks=0.0.0.0/0


gcloud sql databases create wordpress \
  --instance=wordpress-db \
  --charset=utf8 \
  --collation=utf8_general_ci


gcloud compute ssh --zone "$ZONE" "wordpress-proxy" --project "$DEVSHELL_PROJECT_ID" --quiet --command "
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy && chmod +x cloud_sql_proxy
export SQL_CONNECTION=$DEVSHELL_PROJECT_ID:$REGION:wordpress-db
./cloud_sql_proxy -instances=$SQL_CONNECTION=tcp:3306 &
"