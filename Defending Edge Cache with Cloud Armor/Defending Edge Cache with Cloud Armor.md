# Defending Edge Cache with Cloud Armor

##

```
export REGION=
```


```
curl -LO raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Defending%20Edge%20Cache%20with%20Cloud%20Armor/quicklabtask1.sh

sudo chmod +x quicklabtask1.sh

./quicklabtask1.sh
```

```
LOAD_BALANCER_IP=$(gcloud compute forwarding-rules list --project=$DEVSHELL_PROJECT_ID --format='value(IP_ADDRESS)')

curl -svo /dev/null http://$LOAD_BALANCER_IP/google.png

for i in `seq 1 50`; do curl http://$LOAD_BALANCER_IP/google.png; done

```

### ***```Note: It might take up to 5 minutes to access the HTTP Load Balancer.```*** 

### ```Now Check the score for First 2 Task  & then go ahead with next Commands otherwise you won't get a score.```

##



```
curl -LO raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Defending%20Edge%20Cache%20with%20Cloud%20Armor/quicklabtask2.sh

sudo chmod +x quicklabtask2.sh

./quicklabtask2.sh
```


```
curl -svo /dev/null http://$LOAD_BALANCER_IP/google.png

gcloud logging read 'resource.type="http_load_balancer" AND jsonPayload.@type="type.googleapis.com/google.cloud.loadbalancing.type.LoadBalancerLogEntry" AND severity>=WARNING' --project=$DEVSHELL_PROJECT_ID --format="json"
```

### ***```Note: It might take up to 5 minutes to so the output so just re-run the aboce commands.```*** 

### Congratulation!!!
