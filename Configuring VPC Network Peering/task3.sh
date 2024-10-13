#TASK 3
ZONE=$(gcloud compute instances list --format="value(ZONE)" | tail -n 2 | head -n 1)

INTERNAL_IP_privatenet=$(gcloud compute instances describe privatenet-us-vm --zone=$ZONE --format="get(networkInterfaces[0].networkIP)")

echo -e "${BOLD_RED}INTERNAL_IP:- ${BOLD_GREEN}$INTERNAL_IP_privatenet${RESET}"

gcloud compute ssh --zone "$ZONE" "mynet-us-vm" --project "$DEVSHELL_PROJECT_ID" --quiet
