

echo ""
echo ""

read -p "Enter ZONE: " ZONE

export REGION="${ZONE%-*}"

gcloud services enable dataproc.googleapis.com

gcloud dataproc clusters create my-cluster \
    --region=$REGION \
    --zone=$ZONE \
    --image-version=2.0-debian10 \
    --optional-components=JUPYTER \
    --project=$DEVSHELL_PROJECT_ID

gcloud dataproc jobs submit spark \
    --cluster=my-cluster \
    --region=$REGION \
    --jars=file:///usr/lib/spark/examples/jars/spark-examples.jar \
    --class=org.apache.spark.examples.SparkPi \
    --project=$DEVSHELL_PROJECT_ID \
    -- \
    1000

gcloud dataproc clusters update my-cluster \
    --region=$REGION \
    --num-workers=3 \
    --project=$DEVSHELL_PROJECT_ID