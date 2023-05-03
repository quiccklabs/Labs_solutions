

sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list

sudo sed -i 's|security.debian.org|archive.debian.org/debian-security/|g' /etc/apt/sources.list 

sudo sed -i '/stretch-updates/d' /etc/apt/sources.list 

sudo sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list.d/backports.list

sudo apt update 

sudo apt-get install puppet -y

puppet --version


