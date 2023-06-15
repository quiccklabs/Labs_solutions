

gcloud compute instance-templates create instance-template-1 --project=$DEVSHELL_PROJECT_ID --machine-type=f1-micro --network-interface=network=default,network-tier=PREMIUM --metadata=^,@^startup-script=\#\ Copyright\ 2021\ Google\ LLC$'\n'\#$'\n'\#\ Licensed\ under\ the\ Apache\ License,\ Version\ 2.0\ \(the\ \"License\"\)\;$'\n'\#\ you\ may\ not\ use\ this\ file\ except\ in\ compliance\ with\ the\ License.\#\ You\ may\ obtain\ a\ copy\ of\ the\ License\ at$'\n'\#$'\n'\#\ http://www.apache.org/licenses/LICENSE-2.0$'\n'\#$'\n'\#\ Unless\ required\ by\ applicable\ law\ or\ agreed\ to\ in\ writing,\ software$'\n'\#\ distributed\ under\ the\ License\ is\ distributed\ on\ an\ \"AS\ IS\"\ BASIS,$'\n'\#\ WITHOUT\ WARRANTIES\ OR\ CONDITIONS\ OF\ ANY\ KIND,\ either\ express\ or\ implied.$'\n'\#\ See\ the\ License\ for\ the\ specific\ language\ governing\ permissions\ and$'\n'\#\ limitations\ under\ the\ License.$'\n'apt-get\ -y\ update$'\n'apt-get\ -y\ install\ git$'\n'apt-get\ -y\ install\ virtualenv$'\n'git\ clone\ https://github.com/GoogleCloudPlatform/python-docs-samples$'\n'cd\ python-docs-samples/iap$'\n'virtualenv\ venv\ -p\ python3$'\n'source\ venv/bin/activate$'\n'pip\ install\ -r\ requirements.txt$'\n'cat\ example_gce_backend.py\ \|$'\n'sed\ -e\ \"s/YOUR_BACKEND_SERVICE_ID/\$\(gcloud\ compute\ backend-services\ describe\ my-backend-service\ --global--format=\"value\(id\)\"\)/g\"\ \|$'\n'\ \ \ \ sed\ -e\ \"s/YOUR_PROJECT_ID/\$\(gcloud\ config\ get-value\ account\ \|\ tr\ -cd\ \"\[0-9\]\"\)/g\"\ \>\ real_backend.py$'\n'gunicorn\ real_backend:app\ -b\ 0.0.0.0:80,@enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --tags=http-server --create-disk=auto-delete=yes,boot=yes,device-name=instance-template-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230509,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any --scopes=https://www.googleapis.com/auth/cloud-platform,https://www.googleapis.com/auth/compute.readonly


gcloud beta compute health-checks create http my-health-check --project=$DEVSHELL_PROJECT_ID --port=80 --request-path=/ --proxy-header=NONE --no-enable-logging --check-interval=5 --timeout=5 --unhealthy-threshold=2 --healthy-threshold=2


gcloud beta compute instance-groups managed create my-managed-instance-group --project=$DEVSHELL_PROJECT_ID --base-instance-name=my-managed-instance-group --size=1 --template=instance-template-1 --zones=us-central1-c,us-central1-f,us-central1-b --target-distribution-shape=EVEN --instance-redistribution-type=PROACTIVE --list-managed-instances-results=PAGELESS --health-check=my-health-check --initial-delay=300 --no-force-update-on-repair && gcloud beta compute instance-groups managed set-autoscaling my-managed-instance-group --project=$DEVSHELL_PROJECT_ID --region=us-central1 --cool-down-period=60 --max-num-replicas=10 --min-num-replicas=1 --mode=off --target-cpu-utilization=0.6


openssl genrsa -out PRIVATE_KEY_FILE 2048

cat > ssl_config <<EOF
[req]
default_bits = 2048
req_extensions = extension_requirements
distinguished_name = dn_requirements
prompt = no
[extension_requirements]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
[dn_requirements]
countryName = US
stateOrProvinceName = CA
localityName = Mountain View
0.organizationName = Cloud
organizationalUnitName = Example
commonName = Test
EOF

openssl req -new -key PRIVATE_KEY_FILE \
 -out CSR_FILE \
 -config ssl_config

openssl x509 -req \
 -signkey PRIVATE_KEY_FILE \
 -in CSR_FILE \
 -out CERTIFICATE_FILE.pem \
 -extfile ssl_config \
 -extensions extension_requirements \
 -days 365


gcloud compute ssl-certificates create my-cert \
 --certificate=CERTIFICATE_FILE.pem \
 --private-key=PRIVATE_KEY_FILE \
 --global



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


gcloud beta compute instance-groups managed rolling-action start-update my-managed-instance-group --project=$DEVSHELL_PROJECT_ID --type='proactive' --max-surge=0 --max-unavailable=3 --min-ready=0 --minimal-action='restart' --replacement-method='substitute' --version=template=https://www.googleapis.com/compute/beta/projects/$DEVSHELL_PROJECT_ID/global/instanceTemplates/instance-template-1 --region=us-central1


gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create allow-iap-traffic --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80,tcp:78 --source-ranges=130.211.0.0/22,35.191.0.0/16













