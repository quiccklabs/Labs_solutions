

gcloud auth list

cloudshell_open --repo_url "https://github.com/terraform-google-modules/docs-examples.git" --print_file "./motd" --dir "firewall_basic" --tutorial "./tutorial.md" --force_new_clone

terraform init

terraform apply --auto-approve

terraform init

terraform apply --auto-approve