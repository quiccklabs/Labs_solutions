
gcloud beta container clusters create gmp-cluster --num-nodes=1 --zone us-central1-f --enable-managed-prometheus

gcloud container clusters get-credentials gmp-cluster --zone=us-central1-f

kubectl create ns gmp-system


gcloud beta container clusters update gmp-cluster  --zone us-central1-f --enable-managed-prometheus


sleep 80

kubectl -n gmp-system apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/main/examples/self-pod-monitoring.yaml


kubectl -n gmp-system apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/main/examples/example-app.yaml



echo $'collection:\n  filter:\n    matchOneOf:\n    - \'{job="prom-example"}\'\n    - \'{__name__=~"job:.+"}\'' | kubectl -n gmp-public patch operatorconfig config --type merge -p "$(cat)"




cat > op-config.yaml <<EOF
apiVersion: monitoring.googleapis.com/v1alpha1
collection:
  filter:
    matchOneOf:
    - '{job="prom-example"}'
    - '{__name__=~"job:.+"}'
kind: OperatorConfig
metadata:
  annotations:
    components.gke.io/layer: addon
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"monitoring.googleapis.com/v1alpha1","kind":"OperatorConfig","metadata":{"annotations":{"components.gke.io/layer":"addon"},"labels":{"addonmanager.kubernetes.io/mode":"Reconcile"},"name":"config","namespace":"gmp-public"}}
  creationTimestamp: "2022-03-14T22:34:23Z"
  generation: 1
  labels:
    addonmanager.kubernetes.io/mode: Reconcile
  name: config
  namespace: gmp-public
  resourceVersion: "2882"
  uid: 4ad23359-efeb-42bb-b689-045bd704f295
EOF


export PROJECT=$(gcloud config get-value project)

gsutil mb -p $PROJECT gs://$PROJECT

gsutil cp op-config.yaml gs://$PROJECT

gsutil -m acl set -R -a public-read gs://$PROJECT







cat > prom-example-config.yaml <<EOF
apiVersion: monitoring.googleapis.com/v1alpha1
kind: PodMonitoring
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"monitoring.googleapis.com/v1alpha1","kind":"PodMonitoring","metadata":{"annotations":{},"labels":{"app.kubernetes.io/name":"prom-example"},"name":"prom-example","namespace":"gmp-test"},"spec":{"endpoints":[{"interval":"30s","port":"metrics"}],"selector":{"matchLabels":{"app":"prom-example"}}}}
  creationTimestamp: "2022-03-14T22:33:55Z"
  generation: 1
  labels:
    app.kubernetes.io/name: prom-example
  name: prom-example
  namespace: gmp-test
  resourceVersion: "2648"
  uid: c10a8507-429e-4f69-8993-0c562f9c730f
spec:
  endpoints:
  - interval: 30s
    port: metrics
  selector:
    matchLabels:
      app: prom-example
status:
  conditions:
  - lastTransitionTime: "2022-03-14T22:33:55Z"
    lastUpdateTime: "2022-03-14T22:33:55Z"
    status: "True"
    type: ConfigurationCreateSuccess
  observedGeneration: 1
EOF


export PROJECT=$(gcloud config get-value project)

gsutil cp prom-example-config.yaml gs://$PROJECT

gsutil -m acl set -R -a public-read gs://$PROJECT