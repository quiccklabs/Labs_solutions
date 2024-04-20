


export REGION="${ZONE%-*}"


gcloud auth list
gsutil cat gs://cloud-training/gsp318/marking/setup_marking_v2.sh | bash
gcloud source repos clone valkyrie-app
cd valkyrie-app
cat > Dockerfile <<EOF
FROM golang:1.10
WORKDIR /go/src/app
COPY source .
RUN go install -v
ENTRYPOINT ["app","-single=true","-port=8080"]
EOF
docker build -t $DOCKER_IMAGE:$TAG_NAME .
cd ..
cd marking
./step1_v2.sh


cd ..
cd valkyrie-app
docker run -p 8080:8080 $DOCKER_IMAGE:$TAG_NAME &
cd ..
cd marking
./step2_v2.sh
bash ~/marking/step2_v2.sh




cd ..
cd valkyrie-app

gcloud artifacts repositories create $REPO_NAME \
    --repository-format=docker \
    --location=$REGION \
    --description="subcribe to quciklab" \
    --async 

gcloud auth configure-docker $REGION-docker.pkg.dev --quiet

sleep 30

Image_ID=$(docker images --format='{{.ID}}')

docker tag $Image_ID $REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/$REPO_NAME/$DOCKER_IMAGE:$TAG_NAME

docker push $REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/$REPO_NAME/$DOCKER_IMAGE:$TAG_NAME


sed -i s#IMAGE_HERE#$REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/$REPO_NAME/$DOCKER_IMAGE:$TAG_NAME#g k8s/deployment.yaml

gcloud container clusters get-credentials valkyrie-dev --zone $ZONE
kubectl create -f k8s/deployment.yaml
kubectl create -f k8s/service.yaml

