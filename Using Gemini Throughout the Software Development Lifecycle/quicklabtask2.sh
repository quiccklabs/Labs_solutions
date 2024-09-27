

echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter PROJECT_ID: " PROJECT_ID

read -p "Enter REGION: " REGION


gcloud config set project $PROJECT_ID

gcloud auth configure-docker --quiet

gcloud auth login

gcloud auth application-default login


gcloud storage cp -r gs://cloud-training/OCBL435/cymbal-superstore .

cd ~/cymbal-superstore/backend
docker build --platform linux/amd64 -t gcr.io/$PROJECT_ID/cymbal-inventory-api .


docker push gcr.io/$PROJECT_ID/cymbal-inventory-api

gcloud run deploy inventory --image=gcr.io/$PROJECT_ID/cymbal-inventory-api --port=8000 --region=$REGION --set-env-vars=PROJECT_ID=$PROJECT_ID --allow-unauthenticated

cd ..

SERVICE_URL=$(gcloud run services describe inventory --region=$REGION --format='value(status.URL)') 

sed -i "s|REPLACE|$SERVICE_URL|g" frontend/.env.production

cd ~/cymbal-superstore/frontend
npm install && npm run build


gcloud storage cp -r build/* gs://$PROJECT_ID-cymbal-frontend



cd ~/cymbal-superstore/backend

rm -rf index.ts

curl -LO https://raw.githubusercontent.com/quiccklabs/Labs_solutions/refs/heads/master/Using%20Gemini%20Throughout%20the%20Software%20Development%20Lifecycle/index.ts

docker build --platform linux/amd64 -t gcr.io/$PROJECT_ID/cymbal-inventory-api .
docker push gcr.io/$PROJECT_ID/cymbal-inventory-api
gcloud run deploy inventory --image=gcr.io/$PROJECT_ID/cymbal-inventory-api --port=8000 --region=us-east1 --set-env-vars=PROJECT_ID=$PROJECT_ID --allow-unauthenticated

cd ~/cymbal-superstore/backend
npm run start
