export my_zone=us-central1-a
export my_cluster=standard-cluster-1

source <(kubectl completion bash)

gcloud container clusters get-credentials $my_cluster --zone $my_zone


git clone https://github.com/GoogleCloudPlatform/training-data-analyst


ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s


cd ~/ak8s/Autoscaling/


kubectl create -f web.yaml --save-config

kubectl expose deployment web --target-port=8080 --type=NodePort


kubectl autoscale deployment web --max 4 --min 1 --cpu-percent 1

kubectl apply -f loadgen.yaml

kubectl scale deployment loadgen --replicas 0

gcloud container node-pools create "temp-pool-1" \
--cluster=$my_cluster --zone=$my_zone \
--num-nodes "2" --node-labels=temp=true --preemptible

kubectl taint node -l temp=true nodetype=preemptible:NoExecute

rm -f web.yaml

cat > web.yaml << EOF

apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 1
  selector:
    matchLabels:
      run: web
  template:
    metadata:
      labels:
        run: web
    spec:
      tolerations:
      - key: "nodetype"
        operator: Equal
        value: "preemptible"
      nodeSelector:
        temp: "true"
      containers:
      - image: gcr.io/google-samples/hello-app:1.0
        name: web
        ports:
        - containerPort: 8080
          protocol: TCP
        resources:
          # You must specify requests for CPU to autoscale
          # based on CPU utilization
          requests:
            cpu: "250m"

EOF



kubectl apply -f web.yaml







