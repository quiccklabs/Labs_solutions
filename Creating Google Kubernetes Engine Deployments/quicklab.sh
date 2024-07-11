

export my_region=$REGION
export my_cluster=autopilot-cluster-1

source <(kubectl completion bash)

gcloud container clusters get-credentials $my_cluster --region $my_region


cat > nginx-deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
EOF

kubectl apply -f ./nginx-deployment.yaml

kubectl get deployments


#task 3

kubectl set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1 

kubectl annotate deployment nginx-deployment kubernetes.io/change-cause="version change to 1.9.1" --overwrite=true

kubectl rollout status deployment.v1.apps/nginx-deployment

kubectl get deployments


cat > service-nginx.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 60000
    targetPort: 80

EOF

kubectl apply -f ./service-nginx.yaml


cat > nginx-canary.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-canary
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
        track: canary
        Version: 1.9.1
    spec:
      containers:
      - name: nginx
        image: nginx:1.9.1
        ports:
        - containerPort: 80
EOF

kubectl apply -f ./nginx-canary.yaml

kubectl get deployments

kubectl scale --replicas=0 deployment nginx-deployment

kubectl get deployments