
# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)


gcloud services enable artifactregistry.googleapis.com

gcloud config set project $PROJECT_ID

gcloud config set compute/region $REGION

gcloud services enable run.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com

gcloud artifacts repositories create caddy-repo --repository-format=docker --location=$REGION --description="Docker repository for Caddy images"

cat > index.html <<EOF_END
<html>
<head>
  <title>My Static Website</title>
</head>
<body>
  <div>Hello from Caddy on Cloud Run!</div>
  <p>This website is served by Caddy running in a Docker container on Google Cloud Run.</p>
</body>
</html>
EOF_END


cat > Caddyfile <<EOF_END
:8080
root * /usr/share/caddy
file_server
EOF_END

cat > Dockerfile <<EOF_END
FROM caddy:2-alpine

WORKDIR /usr/share/caddy

COPY index.html .
COPY Caddyfile /etc/caddy/Caddyfile
EOF_END

docker build -t $REGION-docker.pkg.dev/$PROJECT_ID/caddy-repo/caddy-static:latest .

docker push $REGION-docker.pkg.dev/$PROJECT_ID/caddy-repo/caddy-static:latest

gcloud run deploy caddy-static --region=$REGION --image $REGION-docker.pkg.dev/$PROJECT_ID/caddy-repo/caddy-static:latest --platform managed --allow-unauthenticated

