







# Create the Cloud SQL instance, configure users, and set authorized networks (your existing commands)
gcloud sql instances create wordpress --tier=db-n1-standard-1 --activation-policy=ALWAYS --zone $ZONE
gcloud sql users set-password --host % root --instance wordpress --password Password1*
ADDRESS=$(gcloud compute instances describe blog --zone=$ZONE --format="get(networkInterfaces[0].accessConfigs[0].natIP)")/32
gcloud sql instances patch wordpress --authorized-networks $ADDRESS --quiet

# SSH into the "blog" VM and run the task2.sh script from GitHub
gcloud compute ssh "blog" --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --quiet --command "sudo apt-get update && sudo apt-get install -y mysql-client && curl -LO https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Migrate%20a%20MySQL%20Database%20to%20Google%20Cloud%20SQL/task2.sh && sudo chmod +x task2.sh && ./task2.sh"
