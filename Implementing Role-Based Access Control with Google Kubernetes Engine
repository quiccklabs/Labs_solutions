

export USER1=

export USER2=

export my_zone=us-central1-a
export my_cluster=standard-cluster-1


source <(kubectl completion bash)

gcloud container clusters get-credentials $my_cluster --zone $my_zone

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s


cd ~/ak8s/RBAC/


kubectl create -f ./my-namespace.yaml


kubectl apply -f ./my-pod.yaml --namespace=production


kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $USER1

kubectl apply -f pod-reader-role.yaml

sed -i "s/\[USERNAME_2_EMAIL\]/${USER2}/" username2-editor-binding.yaml



------------------------------------------------------------------------------------------------------------------------------------------------------



LOGIN -> USERNAME_2


export my_zone=us-central1-a
export my_cluster=standard-cluster-1

source <(kubectl completion bash)

gcloud container clusters get-credentials $my_cluster --zone $my_zone

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s

cd ~/ak8s/RBAC/

kubectl apply -f ./production-pod.yaml


------------------------------------------------------------------------------------------------------------------------------------------------------



LOGIN -> USER_NAME_1

kubectl apply -f username2-editor-binding.yaml
kubectl get rolebinding --namespace production


------------------------------------------------------------------------------------------------------------------------------------------------------


LOGIN -> USER_NAME_2

kubectl apply -f ./production-pod.yaml



------------------------------------------------------------------------------------------------------------------------------------------------------




















