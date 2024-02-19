

export my_region=$REGION

export my_cluster=autopilot-cluster-1


gcloud container clusters create-auto $my_cluster --region $my_region

gcloud container clusters get-credentials $my_cluster --region $my_region

kubectl config view

kubectl cluster-info

kubectl config current-context

kubectl config get-contexts

kubectl config use-context gke_${DEVSHELL_PROJECT_ID}_us-central1_autopilot-cluster-1


kubectl create deployment --image nginx nginx-1

sleep 30

my_nginx_pod=$(kubectl get pods -o=jsonpath='{.items[0].metadata.name}')


kubectl top nodes

cat > test.html <<EOF_END
<html> <header><title>This is title</title></header>
<body> Hello world </body>
</html>
EOF_END

kubectl cp ~/test.html $my_nginx_pod:/usr/share/nginx/html/test.html

kubectl expose pod $my_nginx_pod --port 80 --type LoadBalancer

kubectl get services

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s

cd ~/ak8s/GKE_Shell/

kubectl apply -f ./new-nginx-pod.yaml

rm new-nginx-pod.yaml 

cat > new-nginx-pod.yaml <<EOF_END
apiVersion: v1
kind: Pod
metadata:
  name: new-nginx
  labels:
    name: new-nginx
spec:
  containers:
  - name: new-nginx
    image: nginx
    ports:
    - containerPort: 80
EOF_END


kubectl apply -f ./new-nginx-pod.yaml

