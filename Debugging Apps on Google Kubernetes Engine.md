## Debugging Apps on Google Kubernetes Engine

##


### ```Now you have to export the ZONE from Setup and requirements task```

```bash
export ZONE=
```

####

```
gcloud config set compute/zone $ZONE

export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud container clusters get-credentials central --zone $ZONE

git clone https://github.com/xiangshen-dk/microservices-demo.git

cd microservices-demo

kubectl apply -f release/kubernetes-manifests.yaml

sleep 30

gcloud logging metrics create Error_Rate_SLI \
  --description="subscribe to quicklab" \
  --log-filter="resource.type=\"k8s_container\" severity=ERROR labels.\"k8s-pod/app\": \"recommendationservice\"" 
```




