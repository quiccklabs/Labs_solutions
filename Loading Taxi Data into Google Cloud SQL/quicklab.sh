
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export BUCKET=${PROJECT_ID}-ml

gcloud sql instances create taxi \
    --tier=db-n1-standard-1 --activation-policy=ALWAYS

gcloud sql users set-password root --host % --instance taxi \
 --password Passw0rd

export ADDRESS=$(wget -qO - http://ipecho.net/plain)/32

gcloud sql instances patch taxi --authorized-networks $ADDRESS --quiet

MYSQLIP=$(gcloud sql instances describe \
taxi --format="value(ipAddresses.ipAddress)")

echo $MYSQLIP

mysql --host=$MYSQLIP --user=root --password=Passw0rd --verbose -e "
CREATE DATABASE IF NOT EXISTS bts;
USE bts;

DROP TABLE IF EXISTS trips;

CREATE TABLE trips (
  vendor_id VARCHAR(16),    
  pickup_datetime DATETIME,
  dropoff_datetime DATETIME,
  passenger_count INT,
  trip_distance FLOAT,
  rate_code VARCHAR(16),
  store_and_fwd_flag VARCHAR(16),
  payment_type VARCHAR(16),
  fare_amount FLOAT,
  extra FLOAT,
  mta_tax FLOAT,
  tip_amount FLOAT,
  tolls_amount FLOAT,
  imp_surcharge FLOAT,
  total_amount FLOAT,
  pickup_location_id VARCHAR(16),
  dropoff_location_id VARCHAR(16)
);"

echo "Database and table setup complete."

