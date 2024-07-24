

export REGION=${ZONE%-*}

gcloud services disable composer.googleapis.com

gcloud services enable composer.googleapis.com

sleep 60

gcloud composer environments create my-composer-environment \
    --location $REGION \
    --image-version composer-3-airflow-2.7.3

export PROJECT_ID=$(gcloud config get-value project)
gsutil mb gs://$PROJECT_ID

export PROJECT_ID=$(gcloud config get-value project)
gcloud composer environments run my-composer-environment \
  --location $REGION variables -- \
  set gcp_project $PROJECT_ID

gcloud composer environments run my-composer-environment \
  --location $REGION variables -- \
  set gcs_bucket gs://$PROJECT_ID

gcloud composer environments run my-composer-environment \
  --location $REGION variables -- \
  set gce_zone $ZONE


#TASK 4

cd ~
gsutil cp gs://spls/gsp606/codelab.py .

sed -i 's|<region>|'"$REGION"'|g' codelab.py


gsutil cp ~/codelab.py gs://$PROJECT_ID

gcloud composer environments run my-composer-environment \
    --location $REGION variables -- \
    set dags_folder gs://$PROJECT_ID

FILE=codelab.py

BUCKETS=$(gsutil list)

for BUCKET in $BUCKETS; do
    gsutil cp $FILE $BUCKET
    if [ $? -eq 0 ]; then
        echo "Successfully uploaded $FILE to $BUCKET"
    else
        echo "Failed to upload $FILE to $BUCKET"
    fi
done

#TASK 5

gcloud composer environments storage dags import \
  --environment my-composer-environment --location $REGION \
  --source gs://pub/shakespeare/rose.txt
