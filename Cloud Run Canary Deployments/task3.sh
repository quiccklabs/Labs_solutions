
gcloud builds repositories create cloudrun-progression \
     --remote-uri="https://github.com/${GITHUB_USERNAME}/cloudrun-progression.git" \
     --connection="cloud-build-connection" --region=$REGION


gcloud builds triggers create github --name="branch" \
   --repository=projects/$PROJECT_ID/locations/$REGION/connections/cloud-build-connection/repositories/cloudrun-progression \
   --build-config='branch-cloudbuild.yaml' \
   --service-account=projects/$PROJECT_ID/serviceAccounts/$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
   --region=$REGION \
   --branch-pattern='[^(?!.*master)].*'


git checkout -b new-feature-1


sed -i "s/v1.0/v1.1/g" app.py

git add . && git commit -m "updated" && git push gcp new-feature-1

BRANCH_URL=$(gcloud run services describe hello-cloudrun --platform managed --region $REGION --format=json | jq --raw-output ".status.traffic[] | select (.tag==\"new-feature-1\")|.url")
echo $BRANCH_URL


gcloud builds triggers create github --name="master" \
   --repository=projects/$PROJECT_ID/locations/$REGION/connections/cloud-build-connection/repositories/cloudrun-progression \
   --build-config='master-cloudbuild.yaml' \
   --service-account=projects/$PROJECT_ID/serviceAccounts/$PROJECT_NUMBER-compute@developer.gserviceaccount.com  \
   --region=$REGION \
   --branch-pattern='master'


git checkout master
git merge new-feature-1
git push gcp master


CANARY_URL=$(gcloud run services describe hello-cloudrun --platform managed --region $REGION --format=json | jq --raw-output ".status.traffic[] | select (.tag==\"canary\")|.url")
echo $CANARY_URL

curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" $CANARY_URL




gcloud builds triggers create github --name="tag" \
   --repository=projects/$PROJECT_ID/locations/$REGION/connections/cloud-build-connection/repositories/cloudrun-progression \
   --build-config='tag-cloudbuild.yaml' \
   --service-account=projects/$PROJECT_ID/serviceAccounts/$PROJECT_NUMBER-compute@developer.gserviceaccount.com  \
   --region=$REGION \
   --tag-pattern='.*'


git tag 1.1
git push gcp 1.1
