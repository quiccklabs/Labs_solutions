echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter ZONE: " ZONE
read -p "Enter KEY_1: " KEY_1
read -p "Enter VALUE_1: " VALUE_1




#export USER_1=student-02-7a9511278cfd@qwiklabs.net


export REGION="${ZONE%-*}"



#gsutil mb -p $DEVSHELL_PROJECT_ID -c $REGION -l $REGION -b on gs://$DEVSHELL_PROJECT_ID-bucket/
#gsutil iam ch user:$USER_1:objectAdmin gs://$DEVSHELL_PROJECT_ID-bucket/


gcloud alpha dataplex lakes create customer-lake \
--display-name="Customer-Lake" \
 --location=$REGION \
 --labels="key_1=$KEY_1,value_1=$VALUE_1"


gcloud dataplex zones create public-zone \
    --lake=customer-lake \
    --location=$REGION \
    --type=RAW \
    --resource-location-type=SINGLE_REGION \
    --display-name="Public-Zone"



gcloud dataplex assets create customer-raw-data --location=$REGION \
            --lake=customer-lake --zone=public-zone \
            --resource-type=STORAGE_BUCKET \
            --resource-name=projects/$DEVSHELL_PROJECT_ID/buckets/$DEVSHELL_PROJECT_ID-customer-bucket \
            --discovery-enabled \
            --display-name="Customer Raw Data"


gcloud dataplex assets create customer-reference-data --location=$REGION \
            --lake=customer-lake --zone=public-zone \
            --resource-type=BIGQUERY_DATASET \
            --resource-name=projects/$DEVSHELL_PROJECT_ID/datasets/customer_reference_data \
            --display-name="Customer Reference Data"



# gcloud dataplex environments create dataplex-lake-env \
#            --project=$DEVSHELL_PROJECT_ID --location=$REGION --lake=customer-lake \
#            --os-image-version=1.0 --compute-node-count 3  --compute-max-node-count 3 



# gcloud data-catalog tag-templates create customer_data_tag_template \
#    --project=$DEVSHELL_PROJECT_ID \
#    --location=$REGION \
#    --display-name="Customer Data Tag Template" \
#    --schema="fields=DataOwner:String,PIIData:Enum(Y,N)"


# gcloud data-catalog tag-templates create customer_data_tag_template \
#    --project=$DEVSHELL_PROJECT_ID \
#    --location=$REGION \
#    --field=id=DataOwner,display-name=Data\ Owner,type=string,required=TRUE \
#    --field=id=PIIData,display-name=PII\ Data,type='enum(Yes|No)',required=TRUE




