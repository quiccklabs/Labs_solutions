
# Securing Google Kubernetes Engine with Cloud IAM and Pod Security Admission







## Export value from lab page 
## Make sure that you running this command on USERNAME 2





```bash
export REGION=
```

```bash
export ZONE=
```

```bash
export CLUSTER_NAME=
```

```
echo $REGION
echo $ZONE
echo $CLUSTER_NAME

```


```bash
gcloud beta container --project "$DEVSHELL_PROJECT_ID" clusters create "$CLUSTER_NAME" --zone "$ZONE" --no-enable-basic-auth --cluster-version "latest" --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" --disk-type "pd-balanced" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/$DEVSHELL_PROJECT_ID/global/networks/default" --subnetwork "projects/$DEVSHELL_PROJECT_ID/regions/$REGION/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --security-posture=standard --workload-vulnerability-scanning=disabled --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-managed-prometheus --enable-shielded-nodes --node-locations "$ZONE"
```


## Now just wait for to this task get complete.


## Make sure your laptop not go for sleep.


## Switch back to USERNAME 1


##       




```bash
export my_zone=
```
```bash
export my_cluster=
```



```bash

source <(kubectl completion bash)

gcloud container clusters get-credentials $my_cluster --zone $my_zone

kubectl create ns baseline-ns
kubectl create ns restricted-ns


 kubectl label --overwrite ns baseline-ns pod-security.kubernetes.io/warn=baseline
 kubectl label --overwrite ns restricted-ns pod-security.kubernetes.io/enforce=restricted

kubectl get ns --show-labels

cat > psa-workload.yaml <<EOF
 apiVersion: v1
 kind: Pod
 metadata:
   name: nginx
   labels:
     app: nginx
 spec:
   containers:
   - name: nginx
     image: nginx
     securityContext:
       privileged: true
EOF

kubectl apply -f psa-workload.yaml --namespace=baseline-ns

kubectl get pods --namespace=baseline-ns -l=app=nginx

kubectl apply -f psa-workload.yaml --namespace=restricted-ns

```
