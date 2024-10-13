#TASK 5

ZONE=$(gcloud compute instances list --format="value(ZONE)" | tail -n 2 | head -n 1)

gcloud compute networks peerings delete peering-1-2 --network=mynetwork

INTERNAL_IP_privatenet=$(gcloud compute instances describe privatenet-us-vm --zone=$ZONE --format="get(networkInterfaces[0].networkIP)")

BOLD_GREEN="\033[1;32m"
BOLD_RED="\033[1;31m"  # Changed to bold red
RESET="\033[0m"

echo -e "${BOLD_RED}INTERNAL_IP :- ${BOLD_GREEN}$INTERNAL_IP_privatenet${RESET}"

gcloud compute ssh --zone "$ZONE" "mynet-us-vm" --project "$DEVSHELL_PROJECT_ID" --quiet
