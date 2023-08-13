








mkdir tfinfra && cd $_

cat > provider.tf <<EOF_END
  provider "google" {
  project = "$DEVSHELL_PROJECT_ID"
  region  = "${ZONE%-*}"
  zone    = "$ZONE"
}
EOF_END


cat > instance.tf <<EOF_END
resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip"
}

resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  zone         = var.instance_zone
  machine_type = var.instance_type

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Allocate a one-to-one NAT IP to the instance
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }
}
EOF_END



cat > variables.tf <<EOF_END
variable "instance_name" {
  type        = string
  description = "Name for the Google Compute instance"
}
variable "instance_zone" {
  type        = string
  description = "Zone for the Google Compute instance"
}
variable "instance_type" {
  type        = string
  description = "Disk type of the Google Compute instance"
  default     = "e2-small"
  }
EOF_END


cat > exp.tf <<EOF_END
resource "google_compute_instance" "another_instance" {
  name         = "terraform-instance-2"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
  # Tells Terraform that this VM instance must be created only after the
  # storage bucket has been created.
  depends_on = [google_storage_bucket.example_bucket]
}
resource "google_storage_bucket" "example_bucket" {
  name     = "$DEVSHELL_PROJECT_ID"
  location = "US"
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

EOF_END


terraform init


terraform plan -var="instance_name=$INSTANCE" -var="instance_zone=$ZONE" 

terraform apply -var="instance_name=$INSTANCE" -var="instance_zone=$ZONE" -auto-approve
