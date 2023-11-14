#!/bin/bash
  if [ ! -f /initialized.txt ]; then
    # install apache, git
    apt-get update
    apt-get install -y apache2 git

# install logging agent
curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
sudo bash add-logging-agent-repo.sh --also-install

# install monitoring agent
curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh --also-install

    # download and unpack files
    cd /
    curl https://storage.googleapis.com/cloud-training/gcpsec/labs/stackdriver-lab.tgz | tar -zxf -
    cd /stackdriver-lab

    # update apache config
    cp /var/www/html/index.html /var/www/html/secure.html
    cp apache2.conf /etc/apache2/apache2.conf
    /etc/init.d/apache2 reload

    # create file showing setup
    touch /initialized.txt
fi
