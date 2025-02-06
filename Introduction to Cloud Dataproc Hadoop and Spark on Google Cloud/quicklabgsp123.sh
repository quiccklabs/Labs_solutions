

export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

PROJECT_ID=`gcloud config get-value project`



PROJECT_NUMBER=$(gcloud projects describe $(gcloud config get-value project) --format="value(projectNumber)")
echo $PROJECT_NUMBER

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
    --role="roles/storage.admin"

sleep 60

gcloud dataproc clusters create qlab --enable-component-gateway --region $REGION --zone $ZONE --master-machine-type e2-standard-4 --master-boot-disk-type pd-balanced --master-boot-disk-size 100 --num-workers 2 --worker-machine-type e2-standard-2 --worker-boot-disk-size 100 --image-version 2.2-debian12 --project $PROJECT_ID

sleep 120


gcloud dataproc clusters delete qlab --region $REGION --quiet

gcloud dataproc clusters create qlab --enable-component-gateway --region $REGION --zone $ZONE --master-machine-type e2-standard-4 --master-boot-disk-type pd-balanced --master-boot-disk-size 100 --num-workers 2 --worker-machine-type e2-standard-2 --worker-boot-disk-size 100 --image-version 2.2-debian12 --project $PROJECT_ID

sleep 120


gcloud dataproc jobs submit spark \
    --cluster=qlab \
    --region=$REGION \
    --class=org.apache.spark.examples.SparkPi \
    --jars=file:///usr/lib/spark/examples/jars/spark-examples.jar \
    -- 1000
