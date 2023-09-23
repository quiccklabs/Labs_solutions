
# TOC Challenge Lab: Logging and Monitoring













### Activate your cloud shell :- 

### Make sure you doing all the task on 2nd PROJECT_ID 


```bash
export PROJECT_ID_2=
```


```bash
gcloud config set project $PROJECT_ID_2

gcloud compute instances create cymbal-instance2 \
  --zone us-central1-f \
  --machine-type=e2-micro \
  --image-family debian-11 \
  --image-project debian-cloud

gcloud logging buckets create $PROJECT_ID_2 --location global --retention-days 365
```

### Congratulation !!!