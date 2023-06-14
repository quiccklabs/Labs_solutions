


gcloud beta container clusters create gmp-cluster --num-nodes=1 --zone us-central1-f --enable-managed-prometheus

gcloud container clusters get-credentials gmp-cluster --zone=us-central1-f

kubectl create ns gmp-test

kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.2.3/examples/example-app.yaml

kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.2.3/examples/pod-monitoring.yaml


git clone https://github.com/GoogleCloudPlatform/prometheus && cd prometheus

git checkout v2.28.1-gmp.4

wget https://storage.googleapis.com/kochasoft/gsp1026/prometheus

chmod a+x prometheus

export PROJECT_ID=$(gcloud config get-value project)

export ZONE=us-central1-f

./prometheus \
  --config.file=documentation/examples/prometheus.yml --export.label.project-id=$PROJECT_ID --export.label.location=$ZONE 

wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz

 tar xvfz node_exporter-1.3.1.linux-amd64.tar.gz

cd node_exporter-1.3.1.linux-amd64

./node_exporter



----------------------------Open a new tab in cloud shell to run the node exporter commands--------------------------------------------------------


cat > config.yaml <<EOF
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: node
    static_configs:
      - targets: ['localhost:9100']
EOF

export PROJECT=$(gcloud config get-value project)

gsutil mb -p $PROJECT gs://$PROJECT

gsutil cp config.yaml gs://$PROJECT

gsutil -m acl set -R -a public-read gs://$PROJECT








