export PROJECT_ID=$(gcloud projects list --format="value(PROJECT_ID)")

export BUCKET=$PROJECT_ID-bucket


cat > quicklab.json <<EOF_END
[
  {
    "origin": ["http://example.com"],
    "method": ["GET"],
    "responseHeader": ["Content-Type"],
    "maxAgeSeconds": 3600
  }
]
EOF_END


gcloud storage buckets update gs://$BUCKET --cors-file=quicklab.json
