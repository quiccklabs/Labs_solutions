
## Manage Kubernetes in Google Cloud: Challenge Lab

### 

***1. Go to log base metric***

***2 Click Create Metric.***
 
***3. Use the following details to configure your metric:***

***Metric type: ```Counter```***
***Log Metric Name :*** ```pod-image-errors```

***4. Enable Show query and in the Query builder box, add the following query:***
``` 
resource.type="k8s_pod"
severity=WARNING
```
 
***5. Click Create Metric.***



### Make sure to use online notepad which I was using 

```bash
export REPO_NAME=

export CLUSTER_NAME=

export ZONE=

export NAMESPACE=

export INTERVAL=

export SERVICE_NAME=
```


```bash
curl -LO raw.githubusercontent.com/quiccklabs/Labs_solutions/master/NEW%20Manage%20Kubernetes%20in%20Google%20Cloud%20Challenge%20Lab/quicklabgsp510.sh
sudo chmod +x quicklabgsp510.sh
./quicklabgsp510.sh
```


***Wait for to command get execute and make sure laptop will not go for sleep***

### Congratulations !!!
