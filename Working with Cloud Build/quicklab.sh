


cat > quickstart.sh <<EOF_END
#!/bin/sh
echo "Hello, world! The time is $(date)."
EOF_END


cat > Dockerfile <<EOF_END
FROM alpine
COPY quickstart.sh /
CMD ["/quickstart.sh"]
EOF_END

chmod +x quickstart.sh

gcloud artifacts repositories create quickstart-docker-repo --repository-format=docker \
    --location=$REGION --description="Docker repository"

gcloud builds submit --tag $REGION-docker.pkg.dev/${DEVSHELL_DEVSHELL_PROJECT_ID}/quickstart-docker-repo/quickstart-image:tag1


cat > cloudbuild.yaml <<EOF_END
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: [ 'build', '-t', 'YourRegionHere-docker.pkg.dev/$DEVSHELL_PROJECT_ID/quickstart-docker-repo/quickstart-image:tag1', '.' ]
images:
- 'YourRegionHere-docker.pkg.dev/$DEVSHELL_PROJECT_ID/quickstart-docker-repo/quickstart-image:tag1'
EOF_END

sed -i "s/YourRegionHere/$REGION/g" cloudbuild.yaml

sleep 20

gcloud builds submit --config cloudbuild.yaml

cat > quickstart.sh <<EOF_END
#!/bin/sh
if [ -z "$1" ]
then
	echo "Hello, world! The time is $(date)."
	exit 0
else
	exit 1
fi
EOF_END


cat > cloudbuild2.yaml <<EOF_END
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: [ 'build', '-t', 'YourRegionHere-docker.pkg.dev/$DEVSHELL_PROJECT_ID/quickstart-docker-repo/quickstart-image:tag1', '.' ]
- name: 'YourRegionHere-docker.pkg.dev/$DEVSHELL_PROJECT_ID/quickstart-docker-repo/quickstart-image:tag1'
  args: ['fail']
images:
- 'YourRegionHere-docker.pkg.dev/$DEVSHELL_PROJECT_ID/quickstart-docker-repo/quickstart-image:tag1'
EOF_END

sed -i "s/YourRegionHere/$REGION/g" cloudbuild2.yaml

gcloud builds submit --config cloudbuild2.yaml

gcloud builds submit --config cloudbuild.yaml
