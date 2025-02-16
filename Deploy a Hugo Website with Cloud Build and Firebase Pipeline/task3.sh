
gcloud builds repositories create hugo-website-build-repository \
  --remote-uri="https://github.com/${GITHUB_USERNAME}/my_hugo_site.git" \
  --connection="cloud-build-connection" --region=$REGION



gcloud builds triggers create github --name="commit-to-master-branch1" \
   --repository=projects/$PROJECT_ID/locations/$REGION/connections/cloud-build-connection/repositories/hugo-website-build-repository \
   --build-config='cloudbuild.yaml' \
   --service-account=projects/$PROJECT_ID/serviceAccounts/$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
   --region=$REGION \
   --branch-pattern='^master$'


cd ~/my_hugo_site

sed -i "3c\title = 'Blogging with Hugo and Cloud Build'" config.toml



git add .
git commit -m "I updated the site title"
git push -u origin master

gcloud builds submit --region=$REGION


sleep 20

LATEST_BUILD_ID=$(gcloud builds list --region=$REGION --format="value(ID)" --limit=1)
gcloud builds log $LATEST_BUILD_ID --region=$REGION


gcloud builds log "$(gcloud builds list --region=$REGION --format='value(ID)' --limit=1)" --region=$REGION | grep "Hosting URL"
LATEST_BUILD_ID=$(gcloud builds list --region=$REGION --format="value(ID)" --limit=1)
gcloud builds log $LATEST_BUILD_ID --region=$REGION


gcloud builds log "$(gcloud builds list --region=$REGION --format='value(ID)' --limit=1)" --region=$REGION | grep "Hosting URL"
