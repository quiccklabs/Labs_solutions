



echo ""
echo ""

read -p "MY_ZONE: " MY_ZONE

gcloud container clusters create webfrontend --zone $MY_ZONE --num-nodes 2

kubectl create deploy nginx --image=nginx:1.17.10

kubectl get pods

kubectl expose deployment nginx --port 80 --type LoadBalancer

kubectl scale deployment nginx --replicas 3
