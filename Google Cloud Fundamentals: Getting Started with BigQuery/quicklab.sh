


bq mk logdata

bq load \
  --source_format=CSV \
  --autodetect \
  logdata.accesslog \
  gs://cloud-training/gcpfci/access_log.csv
