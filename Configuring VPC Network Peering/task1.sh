#TASK 1

ZONE=$(gcloud compute instances list --format="value(ZONE)" | tail -n 2 | head -n 1)

# Retrieve the internal and external IPs and store them in variables
INTERNAL_IP_privatenet=$(gcloud compute instances describe privatenet-us-vm --zone=$ZONE --format="get(networkInterfaces[0].networkIP)")
EXTERNAL_IP_privatenet=$(gcloud compute instances describe privatenet-us-vm --zone=$ZONE --format="get(networkInterfaces[0].accessConfigs[0].natIP)")


BOLD_GREEN="\033[1;32m"
BOLD_RED="\033[1;31m"  # Changed to bold red
RESET="\033[0m"

echo -e "${BOLD_RED}External:- ${BOLD_GREEN}$EXTERNAL_IP_privatenet${RESET}"
echo -e "${BOLD_RED}Internal IP: :- ${BOLD_GREEN}$INTERNAL_IP_privatenet${RESET}"


gcloud compute ssh --zone "$ZONE" "mynet-us-vm" --project "$DEVSHELL_PROJECT_ID" --quiet
