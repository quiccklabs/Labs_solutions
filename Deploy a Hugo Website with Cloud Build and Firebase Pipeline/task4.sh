

sed -i "s/My New Hugo Site/logging with Hugo and Cloud Build/g" config.toml

git add .
git commit -m "I updated the site title"
git push -u origin main

gcloud builds list --region=$REGION

gcloud builds log --region=$REGION $(gcloud builds list --format='value(ID)' --filter=$(git rev-parse HEAD) --region=$REGION)

gcloud builds log "$(gcloud builds list --format='value(ID)' --filter=$(git rev-parse HEAD) --region=$REGION)" --region=$REGION | grep "Hosting URL"



sleep 20


sed -i "s/Blogging with Hugo and Cloud Build/logging with Hugo and Cloud Build/g" config.toml

git add .
git commit -m "I updated the site title"
git push -u origin main

gcloud builds list --region=$REGION

gcloud builds log --region=$REGION $(gcloud builds list --format='value(ID)' --filter=$(git rev-parse HEAD) --region=$REGION)

gcloud builds log "$(gcloud builds list --format='value(ID)' --filter=$(git rev-parse HEAD) --region=$REGION)" --region=$REGION | grep "Hosting URL"
