echo ""
echo ""

read -p "ENTER REGION:- " REGION


export GCLOUD_PROJECT=$DEVSHELL_PROJECT_ID
export GCLOUD_LOCATION=$REGION


gcloud auth list 

mkdir genkit-intro && cd genkit-intro
npm init -y

npm install -D genkit-cli@1.0.0-rc.2

npm install genkit@1.0.0-rc.2 --save
npm install @genkit-ai/vertexai@1.0.0-rc.2 @genkit-ai/google-cloud@1.0.0-rc.2 express --save
npm install @genkit-ai/dev-local-vectorstore@1.0.0-rc.2 @genkit-ai/evaluator@1.0.0-rc.2 --save

mkdir src && cd src

## add file 

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/refs/heads/master/Build%20a%20RAG%20Solution%20with%20Firebase%20Genkit/index.ts

sed -i "s/us-west1/$REGION/g" index.ts

cd ..

gcloud storage cp ~/genkit-intro/package.json gs://$GCLOUD_PROJECT
gcloud storage cp ~/genkit-intro/src/index.ts gs://$GCLOUD_PROJECT

## edit file 


gcloud storage cp ~/genkit-intro/src/index.ts gs://$GCLOUD_PROJECT


## TASK 3

cd ~/genkit-intro
npx genkit start -- npx tsx src/index.ts | tee -a response_output.json
