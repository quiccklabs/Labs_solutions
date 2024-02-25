
# ```Cloud SQL with Cloud Run [APPRUN]```



```bash
export REGION=
```

```bash
gcloud services enable run.googleapis.com

gcloud config set compute/region $REGION

gcloud sql instances create poll-database \
    --database-version=POSTGRES_13 \
    --tier=db-custom-6-32768 \
    --region=$REGION \
    --root-password=secretpassword

gcloud sql connect poll-database --user=postgres --database=postgres 
```

***Enter the Cloud SQL password when requested :-*** ```secretpassword```

```
CREATE TABLE IF NOT EXISTS votes
( vote_id SERIAL NOT NULL, time_cast timestamp NOT NULL,
candidate VARCHAR(6) NOT NULL, PRIMARY KEY (vote_id) );


CREATE TABLE IF NOT EXISTS totals
( total_id SERIAL NOT NULL, candidate VARCHAR(6) NOT NULL,
num_votes INT DEFAULT 0, PRIMARY KEY (total_id) );

INSERT INTO totals (candidate, num_votes) VALUES ('TABS', 0);


INSERT INTO totals (candidate, num_votes) VALUES ('SPACES', 0);
```


***To exit from the Cloud SQL Instance type:-*** ```\q```




```
CLOUD_SQL_CONNECTION_NAME=$(gcloud sql instances describe poll-database --format='value(connectionName)')

gcloud beta run deploy poll-service \
   --image gcr.io/qwiklabs-resources/gsp737-tabspaces \
   --region $REGION \
   --allow-unauthenticated \
   --add-cloudsql-instances=$CLOUD_SQL_CONNECTION_NAME \
   --set-env-vars "DB_USER=postgres" \
   --set-env-vars "DB_PASS=secretpassword" \
   --set-env-vars "DB_NAME=postgres" \
   --set-env-vars "CLOUD_SQL_CONNECTION_NAME=$CLOUD_SQL_CONNECTION_NAME"

POLL_APP_URL=$(gcloud run services describe poll-service --platform managed --region $REGION --format="value(status.address.url)")
```


