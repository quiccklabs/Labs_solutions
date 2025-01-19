mkdir ~/genkit-intro/data

cat <<EOF > ~/genkit-intro/data/questions.json
[
  {
    "input": {
        "question": "What's on the menu today?"
    }
  },
  {
    "input": {
        "question": "Are there any burgers in the menu today?"
    }
  }
]
EOF


cd ~/genkit-intro
npx genkit eval:flow ragMenuQuestion --input data/questions.json --output application_result.json

gcloud storage cp -r ~/genkit-intro/data gs://$DEVSHELL_PROJECT_ID
gcloud storage cp ~/genkit-intro/application_result.json gs://$DEVSHELL_PROJECT_ID
gcloud storage cp ~/genkit-intro/src/index.ts gs://$DEVSHELL_PROJECT_ID
