
cd ~
/tmp/installhugo.sh

export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")
sudo apt-get update -y
sudo apt-get install git -y
sudo apt-get install gh -y


curl -sS https://webi.sh/gh | sh

gh auth login
gh api user -q ".login"
GITHUB_USERNAME=$(gh api user -q ".login")
git config --global user.name "${GITHUB_USERNAME}"
git config --global user.email "${USER_EMAIL}"
echo ${GITHUB_USERNAME}
echo ${USER_EMAIL}


cd ~
gh repo create  my_hugo_site --private 
gh repo clone  my_hugo_site 

cd ~
/tmp/hugo new site my_hugo_site --force

cd ~/my_hugo_site
git clone \
  https://github.com/rhazdon/hugo-theme-hello-friend-ng.git themes/hello-friend-ng
echo 'theme = "hello-friend-ng"' >> config.toml

sudo rm -r themes/hello-friend-ng/.git
sudo rm themes/hello-friend-ng/.gitignore 

cd ~/my_hugo_site
/tmp/hugo server -D --bind 0.0.0.0 --port 8080


