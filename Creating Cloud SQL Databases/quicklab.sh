



gcloud sql instances create postgresql-db \
--database-version=POSTGRES_14 \
--zone=$ZONE \
--tier=db-custom-1-3840 \
--root-password=subscribe_to_quicklab \
--edition=ENTERPRISE


gcloud sql databases create petsdb --instance=postgresql-db


gcloud sql instances create mysql-db --tier=db-n1-standard-1 --zone=$ZONE

gcloud compute instances create test-client  --zone=$ZONE --image-family=debian-11 --image-project=debian-cloud --machine-type=e2-micro


INSTANCE_NAME="mysql-db"
EXTERNAL=$(gcloud compute instances list --format='value(EXTERNAL_IP)')


gcloud sql instances patch $INSTANCE_NAME \
  --authorized-networks=$EXTERNAL \
  --quiet


# Export the public IP address of the Cloud SQL instance
INSTANCE_NAME="mysql-db"
PUBLIC_IP=$(gcloud sql instances describe $INSTANCE_NAME --format="value(ipAddresses.ipAddress)")

# SSH into the test client
gcloud compute ssh test-client --zone=$ZONE <<EOF
  # Update package lists
  sudo apt-get update

  # Install MySQL client
  sudo apt-get install -y default-mysql-client

  # Log in to the database server
  mysql --host=$PUBLIC_IP --user=root --password
EOF

sleep 20


gcloud compute ssh test-client --zone=$ZONE <<EOF
  # Update package lists
  sudo apt-get update

  # Install MySQL client
  sudo apt-get install -y default-mysql-client

  # Log in to the database server
  mysql --host=$PUBLIC_IP --user=root --password
EOF


sleep 20


gcloud compute ssh test-client --zone=$ZONE <<EOF
  # Update package lists
  sudo apt-get update

  # Install MySQL client
  sudo apt-get install -y default-mysql-client

  # Log in to the database server
  mysql --host=$PUBLIC_IP --user=root --password
EOF
