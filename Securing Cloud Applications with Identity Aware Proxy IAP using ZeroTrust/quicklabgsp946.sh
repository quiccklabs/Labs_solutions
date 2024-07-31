gcloud auth list
git clone https://github.com/googlecodelabs/user-authentication-with-iap.git
cd user-authentication-with-iap

cd 1-HelloWorld

gcloud app create --project=$(gcloud config get-value project) --region=$REGION

sed -i "15c\runtime: python38" app.yaml
sleep 30
gcloud app deploy --quiet


cd ~/user-authentication-with-iap/2-HelloUser
sed -i "15c\runtime: python38" app.yaml
sleep 30
gcloud app deploy --quiet
