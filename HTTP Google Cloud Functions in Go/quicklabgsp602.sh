#!/bin/bash

gcloud services enable cloudfunctions.googleapis.com

curl -LO https://github.com/GoogleCloudPlatform/golang-samples/archive/main.zip

unzip main.zip

cd golang-samples-main/functions/codelabs/gopher

gcloud functions deploy HelloWorld --runtime go120 --trigger-http --quiet

gcloud functions deploy Gopher --runtime go120 --trigger-http --quiet
