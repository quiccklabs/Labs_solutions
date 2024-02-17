

gcloud config set project $DEVSHELL_PROJECT_ID


cat > server.js <<EOF_END
var http = require('http');
var handleRequest = function(request, response) {
  response.writeHead(200);
  response.end("Hello World!");
}
var www = http.createServer(handleRequest);
www.listen(8080);
EOF_END



cat > Dockerfile <<EOF_END
FROM node:6.9.2
EXPOSE 8080
COPY server.js .
CMD node server.js
EOF_END

docker build -t gcr.io/$DEVSHELL_PROJECT_ID/hello-node:v1 .

docker run -d -p 8080:8080 gcr.io/$DEVSHELL_PROJECT_ID/hello-node:v1

curl http://localhost:8080

ID=$(docker ps --format '{{.ID}}')

docker stop $ID

gcloud auth configure-docker --quiet

docker push gcr.io/$DEVSHELL_PROJECT_ID/hello-node:v1


gcloud container clusters create hello-world \
                --num-nodes 2 \
                --machine-type n1-standard-1 \
                --zone "$ZONE"


kubectl create deployment hello-node \
    --image=gcr.io/$DEVSHELL_PROJECT_ID/hello-node:v1

kubectl get deployments

kubectl get pods

kubectl cluster-info

kubectl config view

kubectl get events


kubectl expose deployment hello-node --type="LoadBalancer" --port=8080

kubectl get services

kubectl scale deployment hello-node --replicas=4

kubectl get deployment

kubectl get pods