#!/bin/bash

# Automatically detect the current Google Cloud Project ID
PROJECT_ID=$(gcloud config get-value project)
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")

echo "Using Project ID: $PROJECT_ID"
echo "Using REGION ID: $REGION"

# Create the Python script automatically
cat <<EOF > gemini_generate.py
import vertexai
from vertexai.generative_models import GenerativeModel

# Initialize Vertex AI
vertexai.init(project="$PROJECT_ID", location="$REGION")

def load_image_from_url(prompt):
    model = GenerativeModel("gemini-2.0-flash")
    response = model.generate_content(prompt)
    print(response.text)

prompt = "Describe how generative AI models can analyze images and text together."
load_image_from_url(prompt)
EOF

echo "Python file created: gemini_generate.py"

# Run the Python script
/usr/bin/python3 gemini_generate.py
