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
#gcloud config set compute/region $region
#gcloud config set compute/zone $region-a
#export ZONE=$region-a



#USER_EMAIL=$(gcloud auth list --limit=1 2>/dev/null | grep '@' | awk '{print $2}')
#----------------------------------------------------code--------------------------------------------------# 

# Create the 'logs' subdirectory
mkdir /home/analyst/logs

# List the contents of the '/home/analyst' directory
ls /home/analyst


echo "${GREEN}${BOLD}

Task 1 Completed

${RESET}"


# Remove the 'temp' directory
rm -r /home/analyst/temp

# List the contents of the '/home/analyst' directory to confirm
ls /home/analyst

echo "${GREEN}${BOLD}

Task 2 Completed

${RESET}"


# Navigate to the /home/analyst/notes directory
cd /home/analyst/notes

# Move the Q3patches.txt file to the /home/analyst/reports directory
mv Q3patches.txt /home/analyst/reports

# List the contents of the /home/analyst/reports directory to confirm
ls /home/analyst/reports

echo "${GREEN}${BOLD}

Task 3 Completed

${RESET}"


# Remove the tempnotes.txt file from the /home/analyst/notes directory
rm /home/analyst/notes/tempnotes.txt

# List the contents of the /home/analyst/notes directory to confirm
ls /home/analyst/notes

echo "${GREEN}${BOLD}

Task 4 Completed

${RESET}"


# Use the touch command to create the tasks.txt file in the /home/analyst/notes directory
touch /home/analyst/notes/tasks.txt

# List the contents of the /home/analyst/notes directory to confirm
ls /home/analyst/notes

echo "${GREEN}${BOLD}

Task 5 Completed

${RESET}"


cat > tasks.txt <<EOF_END
  Completed tasks
  1. Managed file structure in /home/analyst
EOF_END

cat tasks.txt

echo "${GREEN}${BOLD}

Task 6 Completed

Lab Completed !!!

${RESET}"
