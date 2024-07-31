cd ~/user-authentication-with-iap/2-HelloUser
sed -i "15c\runtime: python38" app.yaml
sleep 30
gcloud app deploy --quiet
