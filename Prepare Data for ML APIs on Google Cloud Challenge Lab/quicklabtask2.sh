
#!/bin/bash
REGION=$(cat /tmp/region.txt)  # Read the value from the file
echo "Using REGION: $REGION"


gcloud auth login --quiet


sleep 20

gcloud dataproc clusters create cluster-e94 --enable-component-gateway --region $REGION --master-machine-type e2-standard-2 --master-boot-disk-type pd-balanced --master-boot-disk-size 100 --num-workers 2 --worker-machine-type e2-standard-2 --worker-boot-disk-type pd-balanced --worker-boot-disk-size 100 --image-version 2.2-debian12 --project $DEVSHELL_PROJECT_ID

ZONE="$(gcloud compute instances list --project=$DEVSHELL_PROJECT_ID --format='value(ZONE)' | head -n 1)"

VM_NAME="$(gcloud compute instances list --project=$DEVSHELL_PROJECT_ID --format='value(NAME)' | head -n 1)"


gcloud compute ssh --zone "$ZONE" "$VM_NAME" --tunnel-through-iap --project "$DEVSHELL_PROJECT_ID" --quiet --command="hdfs dfs -cp gs://cloud-training/gsp323/data.txt /data.txt"

gcloud compute ssh --zone "$ZONE" "$VM_NAME" --tunnel-through-iap --project "$DEVSHELL_PROJECT_ID" --quiet --command="gsutil cp gs://cloud-training/gsp323/data.txt /data.txt"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER_EMAIL \
  --role=roles/dataproc.editor

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER_EMAIL \
  --role=roles/storage.objectViewer

gcloud dataproc jobs submit spark \
  --cluster=cluster-e94 \
  --region=$REGION \
  --class=org.apache.spark.examples.SparkPageRank \
  --jars=file:///usr/lib/spark/examples/jars/spark-examples.jar \
  --project=$DEVSHELL_PROJECT_ID \
  -- /data.txt


