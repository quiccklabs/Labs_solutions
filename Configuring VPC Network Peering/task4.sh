#TASK 4
ZONE=$(gcloud compute instances list --format="value(ZONE)" | tail -n 2 | head -n 1)

INTERNAL_IP_mynet_us_vm=$(gcloud compute instances describe mynet-us-vm --zone=$ZONE --format="get(networkInterfaces[0].networkIP)")

BOLD_GREEN="\033[1;32m"
BOLD_RED="\033[1;31m"  # Changed to bold red
RESET="\033[0m"

echo -e "${BOLD_RED}INTERNAL_IP :- ${BOLD_GREEN}$INTERNAL_IP_mynet_us_vm${RESET}"

gcloud compute ssh --zone "$ZONE" "privatenet-us-vm" --project "$DEVSHELL_PROJECT_ID" --quiet
