

#!/bin/bash

# Update the package list
sudo apt-get update

# Install git
sudo apt-get -y -qq install git

# Install python-mpltoolkits.basemap
sudo apt-get install python-mpltoolkits.basemap -y

# Check Git version
git --version

# Clone the repository
git clone https://github.com/GoogleCloudPlatform/training-data-analyst

# Navigate to the appropriate directory
cd training-data-analyst/CPB100/lab2b

# Run the necessary scripts
bash ingest.sh
bash install_missing.sh
python3 transform.py

# List the files in the directory
ls -l

export DEVSHELL_PROJECT_ID=$(gcloud config get-value project)

# Copy files to Google Cloud Storage
gsutil cp earthquakes.* gs://$DEVSHELL_PROJECT_ID/earthquakes/
