#GSP207



gcloud services disable dataflow.googleapis.com

gcloud services enable dataflow.googleapis.com

gsutil mb gs://$DEVSHELL_PROJECT_ID-bucket


cat <<EOF > Dockerfile
# Use the official Python 3.9 image as a base
FROM python:3.9

# Set environment variables for GCP project and region
ARG $DEVSHELL_PROJECT_ID
ARG $REGION

# Install Apache Beam with GCP extras
RUN pip install 'apache-beam[gcp]'==2.42.0

# Set up the GCP bucket path
ENV BUCKET=gs://\${DEVSHELL_PROJECT_ID}-bucket

# Copy the script into the container
COPY run_beam.sh /run_beam.sh

# Give execute permission to the script
RUN chmod +x /run_beam.sh

# Execute the script
CMD ["/run_beam.sh"]
EOF


cat <<EOF > run_beam.sh
#!/bin/bash

# Set necessary environment variables
export DEVSHELL_PROJECT_ID=\${DEVSHELL_PROJECT_ID}
export REGION=\${REGION}
export BUCKET=gs://\${DEVSHELL_PROJECT_ID}-bucket

# Run the local WordCount example to ensure installation
python -m apache_beam.examples.wordcount --output OUTPUT_FILE

# Run the WordCount example using the Dataflow runner
python -m apache_beam.examples.wordcount --project \$DEVSHELL_PROJECT_ID \
  --runner DataflowRunner \
  --staging_location \$BUCKET/staging \
  --temp_location \$BUCKET/temp \
  --output \$BUCKET/results/output \
  --region \$REGION
EOF


# Build the Docker image
docker build --build-arg DEVSHELL_PROJECT_ID=$DEVSHELL_PROJECT_ID --build-arg REGION=$REGION -t beam-dataflow:latest .

# Run the Docker container
docker run -it -e DEVSHELL_PROJECT_ID=$DEVSHELL_PROJECT_ID -e REGION=$REGION beam-dataflow:latest

