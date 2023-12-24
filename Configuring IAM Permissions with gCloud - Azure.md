

### Configuring IAM Permissions with gCloud - Azure

### Open the list of compute instances by going to Navigation Menu > Compute Engine > VM instances.

### On the line with the compute instance named centos-clean, click SSH.




```bash
export ZONE_1=
```
```bash
export ZONE_2=
```

```bash
export SECOND_USER_NAME=
```
```bash
export SECOND_PROJECT_ID=
```



```bash
gcloud --version

gcloud auth login --no-launch-browser --quiet
```

```bash
sudo yum install google-cloud-cli -y

gcloud config set compute/zone "$ZONE_1"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "${ZONE_1%-*}"
export REGION=$(gcloud config get compute/region)


gcloud compute instances create lab-1 --zone=$ZONE

gcloud config set compute/zone $ZONE_2

gcloud init --no-launch-browser
```

### Select option 2, Create a new configuration.

### configuration name: Type ***user2***

### Make sure to choose your 1st project id .

```bash

gcloud config configurations activate default

gcloud config configurations activate user2

echo "export PROJECTID2=$SECOND_PROJECT_ID" >> ~/.bashrc

. ~/.bashrc
gcloud config set project $PROJECTID2 --quiet

gcloud config configurations activate default

sudo yum -y install epel-release
sudo yum -y install jq

echo "export USERID2=$SECOND_USER_NAME" >> ~/.bashrc

. ~/.bashrc
gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=roles/viewer


gcloud config configurations activate user2

gcloud config set project $PROJECTID2

gcloud compute instances create lab-2

gcloud config configurations activate default

gcloud iam roles create devops --project $PROJECTID2 --permissions "compute.instances.create,compute.instances.delete,compute.instances.start,compute.instances.stop,compute.instances.update,compute.disks.create,compute.subnetworks.use,compute.subnetworks.useExternalIp,compute.instances.setMetadata,compute.instances.setServiceAccount"

gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=projects/$PROJECTID2/roles/devops

gcloud config configurations activate user2

gcloud compute instances create lab-2

gcloud config configurations activate default

gcloud config set project $PROJECTID2

gcloud iam service-accounts create devops --display-name devops

gcloud iam service-accounts list  --filter "displayName=devops"

SA=$(gcloud iam service-accounts list --format="value(email)" --filter "displayName=devops")

gcloud projects add-iam-policy-binding $PROJECTID2 --member serviceAccount:$SA --role=roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $PROJECTID2 --member serviceAccount:$SA --role=roles/compute.instanceAdmin

gcloud compute instances create lab-3 --service-account $SA --scopes "https://www.googleapis.com/auth/compute"

gcloud compute instances create lab-2 --zone=$ZONE_2

sudo yum install google-cloud-cli -y
```

