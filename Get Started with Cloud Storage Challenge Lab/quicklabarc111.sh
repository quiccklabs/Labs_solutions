

#!/bin/bash

# Define color variables
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)

BG_BLACK=$(tput setab 0)
BG_RED=$(tput setab 1)
BG_GREEN=$(tput setab 2)
BG_YELLOW=$(tput setab 3)
BG_BLUE=$(tput setab 4)
BG_MAGENTA=$(tput setab 5)
BG_CYAN=$(tput setab 6)
BG_WHITE=$(tput setab 7)

BOLD=$(tput bold)
RESET=$(tput sgr0)






#form 1
# Function to run form 1 code
run_form_1() {
export BUCKET="$(gcloud config get-value project)"		

gsutil mb -p $BUCKET gs://$Bucket_1

gsutil retention set 30s gs://$Bucket_2

echo "subscibe to quicklab" > sample.txt

gsutil cp sample.txt gs://$Bucket_3/
}



#form 2
# Function to run form 2 code
run_form_2() {
		

gsutil mb -c nearline gs://$Bucket_1

gcloud alpha storage buckets update gs://$Bucket_2 --no-uniform-bucket-level-access

gsutil acl ch -u $USER_EMAIL:OWNER gs://$Bucket_2

gsutil rm gs://$Bucket_2/sample.txt

echo "subscibe to quicklab" > sample.txt

gsutil cp sample.txt gs://$Bucket_2

gsutil acl ch -u allUsers:R gs://$Bucket_2/sample.txt

gcloud storage buckets update gs://$Bucket_3 --update-labels=key=value
}


#form 3
# Function to run form 3 code
run_form_3() {


gsutil mb -c coldline gs://$Bucket_1

echo "This is an example of editing the file content for cloud storage object" | gsutil cp - gs://$Bucket_2/sample.txt

gsutil defstorageclass set ARCHIVE gs://$Bucket_3
}


# Main script block
echo "${YELLOW}${BOLD}"

read -p "Enter the Bucket_1: " Bucket_1
read -p "Enter the Bucket_2: " Bucket_2
read -p "Enter the Bucket_3: " Bucket_3

echo "${RESET}${BOLD}"

echo "${BLUE}${BOLD}"

# Get the form number from user input
read -p "Enter the Form number (1, 2, or 3): " form_number

# Execute the appropriate function based on the selected form number
case $form_number in
    1) run_form_1 ;;
    2) run_form_2 ;;
    3) run_form_3 ;;
    *) echo "Invalid form number. Please enter 1, 2, or 3." ;;
esac
