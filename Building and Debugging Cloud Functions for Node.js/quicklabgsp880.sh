

#!/bin/bash

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)





# gcloud auth login

mkdir ff-app && cd $_ 

npm init --y

npm install @google-cloud/functions-framework


sed -i "s/4.0.0/3.1.2/g" package.json


cat > index.js <<EOF
exports.validateTemperature = async (req, res) => {
 try {

    if (!req.body.temp) {
        throw "Temperature is undefined \n";
      }

   if (req.body.temp < 100) {
     res.status(200).send("Temperature OK \n");
   } else {
     res.status(200).send("Too hot \n");
   }
 } catch (error) {
   //return an error
   console.log("got error: ", error);
   res.status(500).send(error);
 }
};
EOF


# cd ff-app

# npx --node-options=--inspect @google-cloud/functions-framework --target=validateTemperature
# npx @google-cloud/functions-framework --target=validateTemperature


# Remove existing lock file and node_modules
rm -rf node_modules package-lock.json

# Install fresh and regenerate lock file
npm install

# (Optional) Check if functions-framework version matches in both files
npm list @google-cloud/functions-framework



gcloud config set project $PROJECT_ID

gcloud functions deploy validateTemperature \
  --trigger-http \
  --runtime nodejs20 \
  --gen2 \
  --allow-unauthenticated \
  --region $REGION 
