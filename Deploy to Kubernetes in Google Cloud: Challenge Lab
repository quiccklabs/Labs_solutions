Task 1:-

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
docker build -t <Docker Image>:<Tag Name> .
cd ..
cd marking
./step1_v2.sh




Task 2:-
cd ..
cd valkyrie-app
docker run -p 8080:8080 <Docker Image>:<Tag Name> &
cd ..
cd marking
./step2_v2.sh
bash ~/marking/step2_v2.sh


Task 3:-

cd ..
cd valkyrie-app

gcloud artifacts repositories create Change_repo \
    --repository-format=docker \
    --location=us-central1 \
    --description="subcribe to quciklab" \
    --async 

gcloud auth configure-docker us-central1-docker.pkg.dev

docker images

docker tag Image_ID us-central1-docker.pkg.dev/PROJECT-ID/REPOSITORY/<Docker Image>:<Tag Name>

docker push us-central1-docker.pkg.dev/PROJECT-ID/REPOSITORY/<Docker Image>:<Tag Name>



Task 4:-

sed -i s#IMAGE_HERE#us-central1-docker.pkg.dev/PROJECT-ID/REPOSITORY/<Docker Image>:<Tag Name>#g k8s/deployment.yaml

gcloud container clusters get-credentials valkyrie-dev --zone us-east1-d
kubectl create -f k8s/deployment.yaml
kubectl create -f k8s/service.yaml


