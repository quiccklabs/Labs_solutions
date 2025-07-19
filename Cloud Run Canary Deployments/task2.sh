
gh repo create cloudrun-progression --private 

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

mkdir cloudrun-progression
cp -r /home/$USER/training-data-analyst/self-paced-labs/cloud-run/canary/*  cloudrun-progression
cd cloudrun-progression

sed -i "s/_REGION: us-central1/_REGION: $REGION/g" branch-cloudbuild.yaml
sed -i "s/_REGION: us-central1/_REGION: $REGION/g" master-cloudbuild.yaml
sed -i "s/_REGION: us-central1/_REGION: $REGION/g" tag-cloudbuild.yaml


sed -e "s/PROJECT/${PROJECT_ID}/g" -e "s/NUMBER/${PROJECT_NUMBER}/g" branch-trigger.json-tmpl > branch-trigger.json
sed -e "s/PROJECT/${PROJECT_ID}/g" -e "s/NUMBER/${PROJECT_NUMBER}/g" master-trigger.json-tmpl > master-trigger.json
sed -e "s/PROJECT/${PROJECT_ID}/g" -e "s/NUMBER/${PROJECT_NUMBER}/g" tag-trigger.json-tmpl > tag-trigger.json


git init
git config credential.helper gcloud.sh
git remote add gcp https://github.com/${GITHUB_USERNAME}/cloudrun-progression
git branch -m master
git add . && git commit -m "initial commit"
git push gcp master


gcloud builds submit --tag gcr.io/$PROJECT_ID/hello-cloudrun
gcloud run deploy hello-cloudrun \
--image gcr.io/$PROJECT_ID/hello-cloudrun \
--platform managed \
--region $REGION \
--tag=prod -q


PROD_URL=$(gcloud run services describe hello-cloudrun --platform managed --region $REGION --format=json | jq --raw-output ".status.url")
echo $PROD_URL
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" $PROD_URL


gcloud builds connections create github cloud-build-connection --project=$PROJECT_ID  --region=$REGION 

gcloud builds connections describe cloud-build-connection --region=$REGION 

