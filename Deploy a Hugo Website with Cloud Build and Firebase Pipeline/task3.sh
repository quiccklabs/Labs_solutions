
cd ~

gcloud builds repositories create hugo-website-build-repository \
  --remote-uri="https://github.com/${GITHUB_USERNAME}/my_hugo_site.git" \
  --connection="cloud-build-connection" --region=$REGION

gcloud builds triggers create github --name="commit-to-main-branch1" \
   --repository=projects/$PROJECT_ID/locations/$REGION/connections/cloud-build-connection/repositories/hugo-website-build-repository \
   --build-config='cloudbuild.yaml' \
   --service-account=projects/$PROJECT_ID/serviceAccounts/$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
   --region=$REGION \
   --branch-pattern='^main$'


cd ~/my_hugo_site


sed -i "s/My New Hugo Site/Blogging with Hugo and Cloud Build/g" config.toml

git add .
git commit -m "I updated the site title"
git push -u origin main

gcloud builds list --region=$REGION

gcloud builds log --region=$REGION $(gcloud builds list --format='value(ID)' --filter=$(git rev-parse HEAD) --region=$REGION)

gcloud builds log "$(gcloud builds list --format='value(ID)' --filter=$(git rev-parse HEAD) --region=$REGION)" --region=$REGION | grep "Hosting URL"
