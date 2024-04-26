## ***Monitor and Log with Google Cloud Operations Suite: Challenge Lab***

### 

***```EXPORT VAULES:-```*** 

```
export METRICS_NAME=
```

```
export ALERT=
```

```
curl -LO raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Monitor%20and%20Log%20with%20Google%20Cloud%20Operations%20Suite%20Challenge%20Lab/quicklabgsp338.sh
sudo chmod +x quicklabgsp338.sh
./quicklabgsp338.sh
```

###

```
gcloud alpha monitoring policies create --policy-from-file="app-engine-error-percent-policy.json"
```

### ***```IF you face the error then wait for 10 - 15 minutes and again re-run the above command```*** 

###
###
### ***```Congratulations:-)```***