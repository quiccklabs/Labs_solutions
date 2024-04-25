## ***Manage Bigtable on Google Cloud: Challenge Lab***

### 

***```EXPORT ZONES:-```*** 

```
export ZONE=
```

***```2nd Zone must be opposite of ZONE 1:-```*** 
```
export ZONE_2=
```

```
curl -LO raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Manage%20Bigtable%20on%20Google%20Cloud%20Challenge%20Lab/quicklabgsp380.sh

sudo chmod +x quicklabgsp380.sh

./quicklabgsp380.sh
```

### ***```Once you get a score on first 4 task then only run the below commands:-```*** 


```
gcloud bigtable backups delete PersonalizedProducts_7 --instance=ecommerce-recommendations \
  --cluster=ecommerce-recommendations-c1  --quiet

gcloud bigtable instances delete ecommerce-recommendations --quiet
```

###
###
### ***```Congratulations:-)```***
