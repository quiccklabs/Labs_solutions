


export REGION="${ZONE%-*}"

gcloud services enable iap.googleapis.com

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

cd ~/training-data-analyst/courses/db-migration/terraform-clients-servers/


sed -i "s/your-project-id-here/$DEVSHELL_PROJECT_ID/g" terraform.tfvars

sed -i "s/qwiklabs_gcp_region/$REGION/g" terraform.tfvars

sed -i "s/qwiklabs_gcp_zone/$ZONE/g" terraform.tfvars



cat > vm-mysql-server.tf <<"EOF"
# Create a MySQL Server in Private VPC
resource "google_compute_instance" "mysql-server" {
  name         = "mysql-server-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = var.gcp_zone_1
  tags         = ["allow-ssh", "allow-mysql"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network        = google_compute_network.private-vpc.name
    subnetwork     = google_compute_subnetwork.private-subnet_1.name
  #  access_config { } 
  }
} 

output "mysql-server" {
  value = google_compute_instance.mysql-server.name
}

output "mysql-server-external-ip" {
  value = "NONE"
}

output "mysql-server-internal-ip" {
  value = google_compute_instance.mysql-server.network_interface.0.network_ip
}
EOF




cat > vm-mysql-client.tf <<"EOF"
# Create MySQL Client in Public VPC
resource "google_compute_instance" "mysql-client" {
  name         = "mysql-client-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = var.gcp_zone_1
  tags         = ["allow-ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network        = google_compute_network.public-vpc.name
    subnetwork     = google_compute_subnetwork.public-subnet_1.name
    access_config { } 
  }
} 


output "mysql-client" {
  value = google_compute_instance.mysql-client.name
}

output "mysql-client-external-ip" {
  value = google_compute_instance.mysql-client.network_interface.0.access_config.0.nat_ip
}

output "mysql-client-internal-ip" {
  value = google_compute_instance.mysql-client.network_interface.0.network_ip
}
EOF



cat > vpc-firewall-rules-private.tf <<"EOF"
# allow MySQL only from public subnet
resource "google_compute_firewall" "private-allow-mysql" {
  name    = "${google_compute_network.private-vpc.name}-allow-mysql"
  network = google_compute_network.private-vpc.name
  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }
  source_ranges = [
    "${var.subnet_cidr_public}"
  ]
  target_tags = ["allow-mysql"] 
}
EOF


cat > cloud-nat.tf <<"EOF"
resource "google_compute_router" "nat-router" {
  name    = "nat-router"
  region  = google_compute_subnetwork.private-subnet_1.region
  network = google_compute_network.private-vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "private-nat" {
  name                               = "private-nat"
  router                             = google_compute_router.nat-router.name
  region                             = google_compute_router.nat-router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
EOF

terraform init
terraform plan

terraform apply -auto-approve







mysql_client=$(gcloud compute instances list --format="value(NAME)" --filter="NAME:('mysql-client-*')")
mysql_server=$(gcloud compute instances list --format="value(NAME)" --filter="NAME:('mysql-server-*')")



cat > prepare_disk.sh <<'EOF_END'
sudo apt-get update
sudo apt-get install -y default-mysql-server
EOF_END

gcloud compute scp prepare_disk.sh $mysql_server:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh $mysql_server --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"



cat > prepare_disk.sh <<'EOF_END'
sudo apt-get update
sudo apt-get install -y default-mysql-client
EOF_END

gcloud compute scp prepare_disk.sh $mysql_client:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh $mysql_client --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"
