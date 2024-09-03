

gcloud auth list

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

#!/bin/bash

sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update
sudo apt-get install vault

vault

nohup vault server -dev > vault_server.log 2>&1 &

sleep 5

export VAULT_ADDR='http://127.0.0.1:8200'

# Check Vault status
vault status

# Continue with other Vault commands



export VAULT_ADDR='http://127.0.0.1:8200'

vault path-help auth/my-auth

vault kv put secret/mysql/webapp db_name="users" username="admin" password="passw0rd"

vault auth enable approle

vault policy write jenkins -<<EOF
# Read-only permission on secrets stored at 'secret/data/mysql/webapp'
path "secret/data/mysql/webapp" {
  capabilities = [ "read" ]
}
EOF

vault write auth/approle/role/jenkins token_policies="jenkins" \
    token_ttl=1h token_max_ttl=4h

vault read auth/approle/role/jenkins

vault read auth/approle/role/jenkins/role-id

vault write -force auth/approle/role/jenkins/secret-id


ROLE_ID=$(vault read -field=role_id auth/approle/role/jenkins/role-id)

SECRET_ID=$(vault write -force -field=secret_id auth/approle/role/jenkins/secret-id)

TOKEN=$(vault write -field=token auth/approle/login role_id="$ROLE_ID" secret_id="$SECRET_ID")

export APP_TOKEN="$TOKEN"

VAULT_TOKEN=$APP_TOKEN vault kv get secret/mysql/webapp

VAULT_TOKEN=$APP_TOKEN vault kv get -format=json secret/mysql/webapp | jq -r .data.data.db_name > db_name.txt
VAULT_TOKEN=$APP_TOKEN vault kv get -format=json secret/mysql/webapp | jq -r .data.data.password > password.txt
VAULT_TOKEN=$APP_TOKEN vault kv get -format=json secret/mysql/webapp | jq -r .data.data.username > username.txt

export PROJECT_ID=$(gcloud config get-value project)
gsutil cp *.txt gs://$PROJECT_ID
