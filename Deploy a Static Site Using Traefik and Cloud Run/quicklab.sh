
#!/bin/bash

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)



gcloud services enable run.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com

gcloud config set project $PROJECT_ID

gcloud config set run/region $REGION

gcloud artifacts repositories create traefik-repo --repository-format=docker --location=$REGION --description="Docker repository for static site images"

mkdir traefik-site && cd traefik-site && mkdir public

cat > public/index.html <<EOF
<html>
<head>
  <title>My Static Website</title>
</head>
<body>
  <p>Hello from my static website on Cloud Run!</p>
</body>
</html>
EOF

gcloud auth configure-docker $REGION-docker.pkg.dev


cat > traefik.yml <<EOF
entryPoints:
  web:
    address: ":8080"

providers:
  file:
    filename: /etc/traefik/dynamic.yml
    watch: true

log:
  level: INFO
EOF



cat > dynamic.yml <<EOF
http:
  routers:
    static-files:
      rule: "PathPrefix(`/`)"
      entryPoints:
        - web
      service: static-service

  services:
    static-service:
      loadBalancer:
        servers:
          - url: "http://localhost:8000"
EOF


cat > Dockerfile <<EOF
FROM alpine:3.20

# Install traefik and caddy
RUN apk add --no-cache traefik caddy

# Copy configs and static files
COPY traefik.yml /etc/traefik/traefik.yml
COPY dynamic.yml /etc/traefik/dynamic.yml
COPY public/ /public/

# Cloud Run uses port 8080
EXPOSE 8080

# Run static server (on 8000) and Traefik (on 8080)
ENTRYPOINT [ "caddy" ]
CMD [ "file-server", "--listen", ":8000", "--root", "/public", "&", "traefik" ]
EOF


docker build -t $REGION-docker.pkg.dev/$PROJECT_ID/traefik-repo/traefik-static-site:latest .

docker push $REGION-docker.pkg.dev/$PROJECT_ID/traefik-repo/traefik-static-site:latest

gcloud run deploy traefik-static-site --image $REGION-docker.pkg.dev/$PROJECT_ID/traefik-repo/traefik-static-site:latest --platform managed --allow-unauthenticated --port 8000

