Task 1:-

Create a Firestore database
To complete this section successfully, you are required to implement the following:

Cloud Firestore Database
Use Firestore Native Mode
Add location Nam5 (United States)

Task 2:-

cd pet-theory/lab06/firebase-import-csv/solution
npm install
node index.js netflix_titles_original.csv


Task 3:-

cd ~/pet-theory/lab06/firebase-rest-api/solution-01
npm install
gcloud builds submit --tag gcr.io/$GOOGLE_CLOUD_PROJECT/rest-api:0.1
gcloud beta run deploy Service_Name --image gcr.io/$GOOGLE_CLOUD_PROJECT/rest-api:0.1 --allow-unauthenticated



Task 4:-

cd ~/pet-theory/lab06/firebase-rest-api/solution-02
npm install
gcloud builds submit --tag gcr.io/$GOOGLE_CLOUD_PROJECT/rest-api:0.2
gcloud beta run deploy Service_Name --image gcr.io/$GOOGLE_CLOUD_PROJECT/rest-api:0.2 --allow-unauthenticated


Goto cloud run and click netflix-dataset-service then copy the url.

SERVICE_URL=<copy url from your netflix-dataset-service>
curl -X GET $SERVICE_URL/2019


Task 5:-

cd ~/pet-theory/lab06/firebase-frontend/public
nano app.js 

# comment line 3 and uncomment line 4, insert your netflix-dataset-service url

npm install
cd ~/pet-theory/lab06/firebase-frontend
gcloud builds submit --tag gcr.io/$GOOGLE_CLOUD_PROJECT/frontend-staging:0.1
gcloud beta run deploy Frontend_Staging_Service_Name --image gcr.io/$GOOGLE_CLOUD_PROJECT/frontend-staging:0.1



Task 6:-

gcloud builds submit --tag gcr.io/$GOOGLE_CLOUD_PROJECT/frontend-production:0.1
gcloud beta run deploy Frontend_Production_Service_Name --image gcr.io/$GOOGLE_CLOUD_PROJECT/frontend-production:0.1


