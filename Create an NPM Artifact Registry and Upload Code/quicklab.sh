
# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)



gcloud services enable artifactregistry.googleapis.com

gcloud config set project $PROJECT_ID

gcloud config set compute/region $REGION

gcloud artifacts repositories create my-npm-repo \
    --repository-format=npm \
    --location=$REGION \
    --description="NPM repository"

mkdir my-npm-package
cd my-npm-package

npm init --scope=@$PROJECT_ID -y

echo 'console.log(`Hello from my-npm-package!`);' > index.js


gcloud artifacts print-settings npm \
    --project=$PROJECT_ID \
    --repository=my-npm-repo \
    --location=$REGION \
    --scope=@$PROJECT_ID > ./.npmrc


gcloud auth configure-docker $REGION-npm.pkg.dev --quiet


cat > package.json <<EOF_END
{
  "name": "@qwiklabs-gcp-00-e9159952f381/my-npm-package",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "artifactregistry-login": "npx google-artifactregistry-auth --repo-config=./.npmrc --credential-config=./.npmrc",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "type": "commonjs"
}
EOF_END

npm run artifactregistry-login -y

cat .npmrc

npm publish --registry=https://$REGION-npm.pkg.dev/$PROJECT_ID/my-npm-repo/
