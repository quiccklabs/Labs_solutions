# Cloud Functions 2nd Gen: Qwik Start 



## IAM & Admin - Audit Logs Configuration

## Steps:

1. Navigate to IAM & Admin > Audit Logs in the Google Cloud Console.

2. Find the Compute Engine API in the list.

3. Click the checkbox next to the Compute Engine API.

4. In the info pane on the right, perform the following actions:

   - Check the box for **Admin Read** log type.
   
   - Check the box for **Data Read** log type.
   
   - Check the box for **Data Write** log type.

5. Click the **Save** button to apply the changes.

## Result:

The Compute Engine API now has Admin Read, Data Read, and Data Write log types enabled in the Audit Logs configuration.




##
##

```
export ZONE=
```

```
export REGION="${ZONE%-*}"
gcloud config set compute/region $REGION
export PROJECT_ID=$(gcloud config get-value project)


gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com



mkdir ~/hello-http && cd $_
touch index.js && touch package.json

cat > index.js <<EOF_END
const functions = require('@google-cloud/functions-framework');

functions.http('helloWorld', (req, res) => {
  res.status(200).send('HTTP with Node.js in GCF 2nd gen!');
});
EOF_END


cat > package.json <<EOF_END
{
  "name": "nodejs-functions-gen2-codelab",
  "version": "0.0.1",
  "main": "index.js",
  "dependencies": {
    "@google-cloud/functions-framework": "^2.0.0"
  }
}
EOF_END
```
####
####

```
gcloud functions deploy nodejs-http-function \
  --gen2 \
  --runtime nodejs16 \
  --entry-point helloWorld \
  --source . \
  --region $REGION \
  --trigger-http \
  --timeout 600s \
  --max-instances 1 \
  --quiet
```

### ``` If you facing error re-run the above command again and again... ```



```
PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$PROJECT_ID" --format='value(project_number)')
SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$SERVICE_ACCOUNT \
  --role roles/pubsub.publisher
  

mkdir ~/hello-storage && cd $_
touch index.js && touch package.json


cat > index.js <<EOF_END
const functions = require('@google-cloud/functions-framework');

functions.cloudEvent('helloStorage', (cloudevent) => {
  console.log('Cloud Storage event with Node.js in GCF 2nd gen!');
  console.log(cloudevent);
});
EOF_END


cat > package.json <<EOF_END
{
  "name": "nodejs-functions-gen2-codelab",
  "version": "0.0.1",
  "main": "index.js",
  "dependencies": {
    "@google-cloud/functions-framework": "^2.0.0"
  }
}
EOF_END


BUCKET="gs://gcf-gen2-storage-$PROJECT_ID"
gsutil mb -l $REGION $BUCKET
```
###
###

```
gcloud functions deploy nodejs-storage-function \
  --gen2 \
  --runtime nodejs16 \
  --entry-point helloStorage \
  --source . \
  --region $REGION \
  --trigger-bucket $BUCKET \
  --trigger-location $REGION \
  --max-instances 1 \
  --quiet
```

### ``` If you facing error re-run the above command again and again... ```

```
echo "Hello World" > random.txt
gsutil cp random.txt $BUCKET/random.txt

gcloud functions logs read nodejs-storage-function \
  --region $REGION --gen2 --limit=100 --format "value(log)"


gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
  --role roles/eventarc.eventReceiver

cd ~
git clone https://github.com/GoogleCloudPlatform/eventarc-samples.git


cd ~/eventarc-samples/gce-vm-labeler/gcf/nodejs


gcloud functions deploy gce-vm-labeler \
  --gen2 \
  --runtime nodejs16 \
  --entry-point labelVmCreation \
  --source . \
  --region $REGION \
  --trigger-event-filters="type=google.cloud.audit.log.v1.written,serviceName=compute.googleapis.com,methodName=beta.compute.instances.insert" \
  --trigger-location $REGION \
  --max-instances 1


gcloud compute instances create instance-1 --zone=$ZONE


mkdir ~/hello-world-colored && cd $_
touch main.py



cat > main.py <<EOF_END
import os

color = os.environ.get('COLOR')

def hello_world(request):
    return f'<body style="background-color:{color}"><h1>Hello World!</h1></body>'
EOF_END

echo > requirements.txt 


COLOR=orange
gcloud functions deploy hello-world-colored \
  --gen2 \
  --runtime python39 \
  --entry-point hello_world \
  --source . \
  --region $REGION \
  --trigger-http \
  --allow-unauthenticated \
  --update-env-vars COLOR=$COLOR \
  --max-instances 1 \
  --quiet



mkdir ~/min-instances && cd $_
touch main.go


cat > main.go <<EOF_END
package p

import (
        "fmt"
        "net/http"
        "time"
)

func init() {
        time.Sleep(10 * time.Second)
}

func HelloWorld(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "Slow HTTP Go in GCF 2nd gen!")
}
EOF_END


echo "module example.com/mod" > go.mod


gcloud functions deploy slow-function \
  --gen2 \
  --runtime go116 \
  --entry-point HelloWorld \
  --source . \
  --region $REGION \
  --trigger-http \
  --allow-unauthenticated \
  --max-instances 4 \
  --quiet

```


## ``` Now check the score for TASK 6 After that run the below commands ```

```
SLOW_URL=$(gcloud functions describe slow-function --region $REGION --gen2 --format="value(serviceConfig.uri)")

hey -n 10 -c 10 $SLOW_URL


gcloud run services delete slow-function --region $REGION --quiet

gcloud functions deploy slow-concurrent-function \
  --gen2 \
  --runtime go116 \
  --entry-point HelloWorld \
  --source . \
  --region $REGION \
  --trigger-http \
  --allow-unauthenticated \
  --min-instances 1 \
  --max-instances 4 \
  --quiet

```
