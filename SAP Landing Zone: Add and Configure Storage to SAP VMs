
export ZONE=

gcloud compute instances start xgl-vm--cerps-bau-dev--dh1--be1ncerps001 --zone=$ZONE



gcloud compute disks create xgl-disk--cerps-bau-dev--dh1--data-disk-01--d-cerpshana1 \
    --description="XYZ-Global disk = CERPS-BaU-Dev - SAP HANA 1 (DH1) - Data disk 01 - virtualhost=d-cerpshana1" \
    \
    --project=$DEVSHELL_PROJECT_ID \
    --zone=$ZONE \
    \
    --type=pd-balanced \
    --size=50

gcloud compute disks create xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1 \
    --description="XYZ-Global disk = CERPS-BaU-Dev - SAP HANA 1 (DH1) - Data disk 02 - virtualhost=d-cerpshana1" \
    \
    --project=$DEVSHELL_PROJECT_ID \
    --zone=$ZONE \
    \
    --type=pd-balanced \
    --size=50



gcloud compute disks create xgl-disk--cerps-bau-dev--dh1--data-disk-03--d-cerpshana1 \
    --description="XYZ-Global disk = CERPS-BaU-Dev - SAP HANA 1 (DH1) - Data disk 03 - virtualhost=d-cerpshana1" \
    \
    --project=$DEVSHELL_PROJECT_ID \
    --zone=$ZONE \
    \
    --type=pd-balanced \
    --size=50



gcloud compute instances attach-disk xgl-vm--cerps-bau-dev--dh1--be1ncerps001 \
    \
    --project=$DEVSHELL_PROJECT_ID \
    --zone=$ZONE \
    \
    --disk=xgl-disk--cerps-bau-dev--dh1--data-disk-01--d-cerpshana1 \
    --device-name=xgl-disk--cerps-bau-dev--dh1--data-disk-01--d-cerpshana1 \
    --mode=rw


gcloud compute instances attach-disk xgl-vm--cerps-bau-dev--dh1--be1ncerps001 \
    \
    --project=$DEVSHELL_PROJECT_ID \
    --zone=$ZONE \
    \
    --disk=xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1 \
    --device-name=xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1 \
    --mode=rw


gcloud compute instances attach-disk xgl-vm--cerps-bau-dev--dh1--be1ncerps001 \
    \
    --project=$DEVSHELL_PROJECT_ID \
    --zone=$ZONE \
    \
    --disk=xgl-disk--cerps-bau-dev--dh1--data-disk-03--d-cerpshana1 \
    --device-name=xgl-disk--cerps-bau-dev--dh1--data-disk-03--d-cerpshana1 \
    --mode=rw




==============================================================================================================================




#TASK 3:- 

# GO TO VM INSTANCE -> OPEN  SSH WINDOW OF  xgl-vm--cerps-bau-dev--dh1--be1ncerps001 


sudo -i
sudo ls -l /dev/disk/by-id

sudo pvcreate /dev/disk/by-id/google-xgl-disk--cerps-bau-dev--dh1--data-disk-01--d-cerpshana1

sudo pvcreate /dev/disk/by-id/google-xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1

sudo pvcreate /dev/disk/by-id/google-xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1


sudo pvdisplay




sudo vgcreate \
    vg--xgl-disk--cerps-bau-dev--dh1--data-disk-01--d-cerpshana1 \
    \
    /dev/disk/by-id/google-xgl-disk--cerps-bau-dev--dh1--data-disk-01--d-cerpshana1


sudo vgcreate \
    vg--xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1 \
    \
    /dev/disk/by-id/google-xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1


sudo vgcreate \
      vg--xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1 \
    \
    /dev/disk/by-id/google-xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1



sudo vgdisplay


sudo lvcreate -l 100%FREE -n lv--hana-shared-DH1 vg--xgl-disk--cerps-bau-dev--dh1--data-disk-01--d-cerpshana1

sudo lvcreate -l 100%FREE -n lv--hana-data-DH1 vg--xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1

sudo lvcreate -l 100%FREE -n lv--hana-log-DH1 vg--xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1

sudo lvdisplay


sudo mkfs \
    -t xfs \
    /dev/vg--xgl-disk--cerps-bau-dev--dh1--data-disk-01--d-cerpshana1/lv--hana-shared-DH1


sudo mkfs \
    -t xfs \
    /dev/vg--xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1/lv--hana-data-DH1


sudo mkfs \
    -t xfs \
    /dev/vg--xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1/lv--hana-log-DH1


sudo mkdir -p /hana/shared/DH1


sudo mkdir -p /hana/data/DH1


sudo mkdir -p /hana/log/DH1


sudo chown -R nobody:nogroup /hana


sudo chown -R nobody:nogroup /hana


sudo chown -R nobody:nogroup /hana


sudo chmod -R 755 /hana

sudo chmod -R 755 /hana

sudo chmod -R 755 /hana

sudo su -
echo "/dev/vg--xgl-disk--cerps-bau-dev--dh1--data-disk-01--d-cerpshana1/lv--hana-shared-DH1  /hana/shared/DH1 xfs defaults,discard,nofail 0 2" >>/etc/fstab
exit

sudo su -
echo "/dev/vg--xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1/lv--hana-data-DH1  /hana/data/DH1 xfs defaults,discard,nofail 0 2" >>/etc/fstab
exit

sudo su -
echo "/dev/vg--xgl-disk--cerps-bau-dev--dh1--data-disk-02--d-cerpshana1/lv--hana-log-DH1  	/hana/log/DH1 xfs defaults,discard,nofail 0 2" >>/etc/fstab
exit


sudo mount -a

sudo df -h




==============================================================================================================================




# GO TO CLOUD SHELL 

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="value(projectNumber)")

gsutil mb \
    -p $DEVSHELL_PROJECT_ID \
    -l us-central1 \
    -c standard \
    --retention 7d \
    --pap enforced \
    gs://xgl-bucket--cerps-bau-dev--dh1--db-backups-$PROJECT_NUMBER



gsutil iam ch serviceAccount:xgl-sa--cerps-bau-dev--dh1-db@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com:objectCreator,objectViewer \
    gs://xgl-bucket--cerps-bau-dev--dh1--db-backups-$PROJECT_NUMBER






    
