

cd ~
/tmp/installhugo.sh

sudo apt-get update
sudo apt-get install git

cd ~
gcloud source repos create my_hugo_site
gcloud source repos clone my_hugo_site

cd ~
/tmp/hugo new site my_hugo_site --force

cd ~/my_hugo_site
git clone \
  https://github.com/budparr/gohugo-theme-ananke.git \
  themes/ananke
echo 'theme = "ananke"' >> config.toml

sudo rm -r themes/ananke/.git
sudo rm themes/ananke/.gitignore 

cd ~/my_hugo_site
  /tmp/hugo server -D --bind 0.0.0.0 --port 8080

