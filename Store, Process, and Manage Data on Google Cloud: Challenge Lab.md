
### Store, Process, and Manage Data on Google Cloud: Challenge Lab

### Activate your cloud shell >_

### Export All Values
```
export BUCKET_NAME=

export TOPIC_NAME=

export FUNCTION_NAME=

export REGION=
```

```
gsutil mb -l $REGION gs://$BUCKET_NAME

gcloud pubsub topics create $TOPIC_NAME


mkdir quicklab

cd quicklab

gcloud services enable run.googleapis.com
gcloud services enable eventarc.googleapis.com

curl -LO https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Store%20Process%20and%20Manage%20Data%20on%20Google%20Cloud%20Challenge%20Lab/index.js

curl -LO https://raw.github.com/quiccklabs/Labs_solutions/master/Store%20Process%20and%20Manage%20Data%20on%20Google%20Cloud%20Challenge%20Lab/package.json

sed -i "s/\$TOPIC_NAME/${TOPIC_NAME}/g" index.js
sed -i "s/\$FUNCTION_NAME/${FUNCTION_NAME}/g" index.js


export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="json(projectNumber)" --quiet | jq -r '.projectNumber')
```
```
  gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member=serviceAccount:service-$PROJECT_NUMBER@gs-project-accounts.iam.gserviceaccount.com  \
    --role=roles/pubsub.publisher
```
### Rerun the above command until you get the output
```
  gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-eventarc.iam.gserviceaccount.com  \
    --role=roles/pubsub.publisher
```
### Rerun the above command until you get the output

```
gcloud functions deploy $FUNCTION_NAME \
  --trigger-bucket $BUCKET_NAME \
  --runtime nodejs16 \
  --gen2 \
  --region $REGION \
  --entry-point $FUNCTION_NAME \
  --allow-unauthenticated \
  --quiet
```

```
curl -LO https://storage.googleapis.com/cloud-training/gsp315/map.jpg

gsutil cp map.jpg gs://$BUCKET_NAME/
```


### Congratulation !!!


