



gcloud storage cp -r gs://partner-genai-bucket/genai049/gen-ai-assessment .

cd gen-ai-assessment
export PROJECT_ID=$(gcloud config get-value project)
gsutil cp gs://${PROJECT_ID}/fpc-manual.pdf .

gcloud auth configure-docker $REGION-docker.pkg.dev

docker build -t cymbal-web-app1 -f Dockerfile .

REPO=$(gcloud artifacts repositories list --location=$REGION --format='value(REPOSITORY)')
REGION=$(gcloud artifacts repositories list --location=$REGION --format='value(LOCATION)')


docker tag cymbal-web-app1 $REGION-docker.pkg.dev/${PROJECT_ID}/${REPO}/cymbal-web-app1
docker push $REGION-docker.pkg.dev/${PROJECT_ID}/${REPO}/cymbal-web-app1

gcloud run deploy $SERVICE_NAME \
    --image=$REGION-docker.pkg.dev/${PROJECT_ID}/${REPO}/cymbal-web-app1 \
    --region=$REGION \
    --allow-unauthenticated \
    --min-instances=0 \
    --max-instances=1


sed -i "s/Hi, I'm FreshBot, what can I do for you?/Hi, I'm FreshBot. What are your food safety questions?/g" main.py

python3 -m venv venv
source venv/bin/activate

docker build -t cymbal-web-app2 -f Dockerfile .

docker tag cymbal-web-app2 $REGION-docker.pkg.dev/${PROJECT_ID}/${REPO}/cymbal-web-app2
docker push $REGION-docker.pkg.dev/${PROJECT_ID}/${REPO}/cymbal-web-app2


gcloud run deploy $SERVICE_NAME \
    --image=$REGION-docker.pkg.dev/${PROJECT_ID}/${REPO}/cymbal-web-app2 \
    --region=$REGION \
    --allow-unauthenticated \
    --min-instances=0 \
    --max-instances=1


## Now your score is 60/100

#TASK 2

rm main.py requirements.txt 

curl -LO https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Deploy%20a%20Generative%20AI%20solution%20using%20a%20RAG%20Framework%20to%20Google%20Cloud%20Challenge%20Lab%20L400/main.py
curl -LO https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Deploy%20a%20Generative%20AI%20solution%20using%20a%20RAG%20Framework%20to%20Google%20Cloud%20Challenge%20Lab%20L400/requirements.txt

POINT=$(gcloud ai index-endpoints list --region=$REGION --format='value(name)' | awk -F'/' '{print $NF}')
echo $POINT

sed -i "s/2534484253186457600/$POINT/g" main.py


pip install -r requirements.txt

docker build -t cymbal-web-app3 -f Dockerfile .


docker tag cymbal-web-app3 $REGION-docker.pkg.dev/${PROJECT_ID}/${REPO}/cymbal-web-app3
docker push $REGION-docker.pkg.dev/${PROJECT_ID}/${REPO}/cymbal-web-app3

gcloud run deploy $SERVICE_NAME \
    --image=$REGION-docker.pkg.dev/${PROJECT_ID}/${REPO}/cymbal-web-app3:latest \
    --region=$REGION \
    --allow-unauthenticated \
    --min-instances=0 \
    --max-instances=1














