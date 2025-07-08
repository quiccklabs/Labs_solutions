

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)



gcloud config set project $PROJECT_ID

gcloud config set run/region $REGION
gcloud services enable run.googleapis.com artifactregistry.googleapis.com

cat > index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>My Static Website</title>
</head>
<body>
    <div>Welcome to My Static Website!</div>
    <p>This website is served from Google Cloud Run using Nginx and Artifact Registry.</p>
</body>
</html>
EOF

cat > nginx.conf <<EOF
events {}
http {
    server {
        listen 8080;
        root /usr/share/nginx/html;
        index index.html index.htm;

        location / {
            try_files \$uri \$uri/ =404;
        }
    }
}
EOF

cat > Dockerfile <<EOF
FROM nginx:latest

COPY index.html /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
EOF


gcloud artifacts repositories create nginx-static-site \
    --repository-format=docker \
    --location=$REGION \
    --description="Docker repository for static website"


docker build -t nginx-static-site .


docker tag nginx-static-site $REGION-docker.pkg.dev/$PROJECT_ID/nginx-static-site/nginx-static-site

docker push $REGION-docker.pkg.dev/$PROJECT_ID/nginx-static-site/nginx-static-site


gcloud run deploy nginx-static-site \
    --image $REGION-docker.pkg.dev/$PROJECT_ID/nginx-static-site/nginx-static-site \
    --platform managed \
    --region $REGION \
    --allow-unauthenticated


gcloud run services describe nginx-static-site --platform managed --region $REGION --format='value(status.url)'
