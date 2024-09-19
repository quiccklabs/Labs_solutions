


ZONE="$(gcloud compute instances list --project=$DEVSHELL_PROJECT_ID --format='value(ZONE)' | head -n 1)"

export REGION="${ZONE%-*}"

gcloud compute networks subnets update default --region=$REGION --enable-private-ip-google-access

gsutil mb -p  $DEVSHELL_PROJECT_ID gs://$DEVSHELL_PROJECT_ID

gsutil mb -p  $DEVSHELL_PROJECT_ID gs://$DEVSHELL_PROJECT_ID-bqtemp

bq mk -d  loadavro


echo "export REGION=$REGION" > env_vars.sh
echo "export PROJECT_ID=$DEVSHELL_PROJECT_ID" >> env_vars.sh


source env_vars.sh


cat > prepare_disk.sh <<'EOF_END'
# Source the environment variables
source /tmp/env_vars.sh


wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/idegc/campaigns.avro

gcloud storage cp campaigns.avro gs://$PROJECT_ID

wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/idegc/dataproc-templates.zip

unzip dataproc-templates.zip

cd dataproc-templates/python

export GCP_PROJECT=$PROJECT_ID
export REGION=$REGION
export GCS_STAGING_LOCATION=gs://$PROJECT_ID
export JARS=gs://cloud-training/dataengineering/lab_assets/idegc/spark-bigquery_2.12-20221021-2134.jar

sleep 60

./bin/start.sh \
-- --template=GCSTOBIGQUERY \
    --gcs.bigquery.input.format="avro" \
    --gcs.bigquery.input.location="gs://$PROJECT_ID" \
    --gcs.bigquery.input.inferschema="true" \
    --gcs.bigquery.output.dataset="loadavro" \
    --gcs.bigquery.output.table="campaigns" \
    --gcs.bigquery.output.mode=overwrite\
    --gcs.bigquery.temp.bucket.name="$PROJECT_ID-bqtemp"

bq query \
 --use_legacy_sql=false \
 'SELECT * FROM `loadavro.campaigns`;'


EOF_END


# Copy the environment variables script to the VM
gcloud compute scp env_vars.sh lab-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

# Copy the prepare_disk.sh script to the VM
gcloud compute scp prepare_disk.sh lab-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

# SSH into the VM and execute the script
gcloud compute ssh lab-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"
