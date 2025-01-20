cd ~/genkit-intro
npx genkit flow:run menuSuggestionFlow '"French"' -s | tee -a output.txt

gcloud storage cp -r ~/genkit-intro/output.txt gs://$DEVSHELL_PROJECT_ID
gcloud storage cp -r ~/genkit-intro/src/index.ts gs://$DEVSHELL_PROJECT_ID
