


gcloud auth list

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -


sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update
sudo apt-get install vault

vault

cat > config.hcl <<EOF_END
storage "raft" {
  path    = "./vault/data"
  node_id = "node1"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = true
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
ui = true

disable_mlock = true
EOF_END

mkdir -p ./vault/data

nohup vault server -config=config.hcl > vault_server.log 2>&1 &

sleep 5

export VAULT_ADDR='http://127.0.0.1:8200'


vault operator init -key-shares=5 -key-threshold=3 > vault_init_output.txt

UNSEAL_KEY_1=$(grep 'Unseal Key 1:' vault_init_output.txt | awk '{print $NF}')
UNSEAL_KEY_2=$(grep 'Unseal Key 2:' vault_init_output.txt | awk '{print $NF}')
UNSEAL_KEY_3=$(grep 'Unseal Key 3:' vault_init_output.txt | awk '{print $NF}')
ROOT_TOKEN=$(grep 'Initial Root Token:' vault_init_output.txt | awk '{print $NF}')

vault operator unseal $UNSEAL_KEY_1
vault operator unseal $UNSEAL_KEY_2
vault operator unseal $UNSEAL_KEY_3

vault login $ROOT_TOKEN

sleep 10

vault secrets enable gcp


#TASK 3

SERVICE_ACCOUNT_EMAIL="$DEVSHELL_PROJECT_ID@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com"

gcloud iam service-accounts keys create ~/$DEVSHELL_PROJECT_ID.json \
  --iam-account $SERVICE_ACCOUNT_EMAIL

gcloud iam service-accounts keys list --iam-account $SERVICE_ACCOUNT_EMAIL

#TASK 4

export VAULT_ADDR='http://127.0.0.1:8200'


vault write gcp/config \
credentials=@/home/$USER/$DEVSHELL_PROJECT_ID.json \
ttl=3600 \
max_ttl=86400


cat > bindings.hcl <<EOF_END
resource "buckets/$DEVSHELL_PROJECT_ID" {
  roles = [
    "roles/storage.objectAdmin",
    "roles/storage.legacyBucketReader",
  ]
}
EOF_END


vault write gcp/roleset/my-token-roleset \
    project="$DEVSHELL_PROJECT_ID" \
    secret_type="access_token"  \
    token_scopes="https://www.googleapis.com/auth/cloud-platform" \
    bindings=@bindings.hcl


TOKEN=$(vault read -field=token gcp/roleset/my-token-roleset/token)


curl "https://storage.googleapis.com/storage/v1/b/$DEVSHELL_PROJECT_ID" \
  --header "Authorization: Bearer $TOKEN" \
  --header "Accept: application/json"


curl -X GET \
  -H "Authorization: Bearer $TOKEN" \
  -o "sample.txt" \
  "https://storage.googleapis.com/storage/v1/b/$DEVSHELL_PROJECT_ID/o/sample.txt?alt=media"


vault write gcp/roleset/my-key-roleset \
    project="$DEVSHELL_PROJECT_ID" \
    secret_type="service_account_key"  \
    bindings=@bindings.hcl

vault read gcp/roleset/my-key-roleset/key


vault write gcp/static-account/my-token-account \
    service_account_email="$SERVICE_ACCOUNT_EMAIL" \
    secret_type="access_token"  \
    token_scopes="https://www.googleapis.com/auth/cloud-platform" \
    bindings=@bindings.hcl

vault write gcp/static-account/my-key-account \
    service_account_email="$SERVICE_ACCOUNT_EMAIL" \
    secret_type="service_account_key"  \
    bindings=@bindings.hcl

export VAULT_ADDR='http://127.0.0.1:8200'


vault write gcp/config \
credentials=@/home/$USER/$DEVSHELL_PROJECT_ID.json \
ttl=3600 \
max_ttl=86400


cat > bindings.hcl <<EOF_END
resource "buckets/$DEVSHELL_PROJECT_ID" {
  roles = [
    "roles/storage.objectAdmin",
    "roles/storage.legacyBucketReader",
  ]
}
EOF_END


vault write gcp/roleset/my-token-roleset \
    project="$DEVSHELL_PROJECT_ID" \
    secret_type="access_token"  \
    token_scopes="https://www.googleapis.com/auth/cloud-platform" \
    bindings=@bindings.hcl
