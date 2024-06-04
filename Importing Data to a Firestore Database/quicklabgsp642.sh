


gcloud config set project $DEVSHELL_PROJECT_ID

gcloud firestore databases create --location=nam5

git clone https://github.com/rosera/pet-theory

cd pet-theory/lab01

npm install @google-cloud/firestore

npm install @google-cloud/logging


curl https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Importing%20Data%20to%20a%20Firestore%20Database/importTestData.js > importTestData.js

npm install faker@5.5.3

curl https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Importing%20Data%20to%20a%20Firestore%20Database/createTestData.js > createTestData.js 


node createTestData 1000

node importTestData customers_1000.csv

npm install csv-parse

node createTestData 20000
node importTestData customers_20000.csv




