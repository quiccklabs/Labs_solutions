#TASK 4

INTERNAL_IP_mynet_us_vm=$(gcloud compute instances describe mynet-us-vm --zone=$ZONE --format="get(networkInterfaces[0].networkIP)")

echo -e "${BOLD_RED}INTERNAL_IP :- ${BOLD_GREEN}$INTERNAL_IP_mynet_us_vm${RESET}"

gcloud compute ssh --zone "$ZONE" "privatenet-us-vm" --project "$DEVSHELL_PROJECT_ID" --quiet
