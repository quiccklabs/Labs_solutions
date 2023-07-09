
gcloud services enable iap.googleapis.com

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

cd ~/training-data-analyst/courses/db-migration/terraform-clients-servers/

cat > terraform.tfvars <<EOF
# GCP Settings
project_id    = "$DEVSHELL_PROJECT_ID"
gcp_region_1  = "us-central1"
gcp_zone_1    = "us-central1-a"

# GCP Network Variables
subnet_cidr_public  = "10.1.1.0/24"
subnet_cidr_private  = "10.2.2.0/24"
EOF



echo 'resource "google_compute_instance" "mysql-server" {
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
}' > vm-mysql-server.tf





echo 'resource "google_compute_instance" "mysql-client" {
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
}' > vm-mysql-client.tf






echo 'resource "google_compute_firewall" "private-allow-ssh" {
  name    = "${google_compute_network.private-vpc.name}-allow-ssh"
  network = google_compute_network.private-vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [
     "35.235.240.0/20"
  ]
  target_tags = ["allow-ssh"] 
}

# allow rdp only from public subnet
resource "google_compute_firewall" "private-allow-rdp" {
  name    = "${google_compute_network.private-vpc.name}-allow-rdp"
  network = google_compute_network.private-vpc.name
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  source_ranges = [
    "${var.subnet_cidr_public}"
  ]
  target_tags = ["allow-rdp"] 
}

# allow ping only from public subnet
resource "google_compute_firewall" "private-allow-ping" {
  name    = "${google_compute_network.private-vpc.name}-allow-ping"
  network = google_compute_network.private-vpc.name
  allow {
    protocol = "icmp"
  }
  source_ranges = [
    "${var.subnet_cidr_public}"
  ]
}

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
}' > vpc-firewall-rules-private.tf


echo 'resource "google_compute_router" "nat-router" {
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
}' > cloud-nat.tf


terraform init
terraform plan

terraform apply -auto-approve


INSTANCE_NAME=$(gcloud compute instances list --filter="name:mysql-client*" --sort-by=~creationTimestamp --limit=1 --format="value(name)")

gcloud compute ssh --zone "us-central1-a" "$INSTANCE_NAME" --quiet --command "sudo apt-get update && sudo apt-get install -y default-mysql-client"


INSTANCE_NAME=$(gcloud compute instances list --filter="name:mysql-client*" --sort-by=~creationTimestamp --limit=1 --format="value(name)")

gcloud compute ssh --zone "us-central1-a" "$INSTANCE_NAME" --quiet --command "sudo apt-get update && sudo apt-get install -y default-mysql-client"




