

Task 1. Create the configuration files

Run in Cloud Shell

touch main.tf
touch variables.tf
mkdir modules
cd modules
mkdir instances
cd instances
touch instances.tf
touch outputs.tf
touch variables.tf
cd ..
mkdir storage
cd storage
touch storage.tf
touch outputs.tf
touch variables.tf
cd


Add the following to the each variables.tf file, and fill in the GCP Project ID:

variable "region" {
 default = "us-central1"
}

variable "zone" {
 default = "us-central1-a"
}

variable "project_id" {
 default = "<REPLACE PROJECT ID>"
}



Add the following to the main.tf file :

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.53.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region

  zone        = var.zone
}

module "instances" {

  source     = "./modules/instances"

}


Run terraform init in Cloud Shell in the root directory to initialize terraform.

If you are getting error after running above command just try this run terraform init -migrate -state  command first 


-----------------------------------------------------------------------------------------------------------------------------------------------------------
Task 2. Import infrastructure

Next, navigate to modules/instances/instances.tf. Copy the following configuration into the file:

resource "google_compute_instance" "tf-instance-1" {
  name         = "tf-instance-1"
  machine_type = "n1-standard-1"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
 network = "default"
  }
  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
  allow_stopping_for_update = true
}

resource "google_compute_instance" "tf-instance-2" {
  name         = "tf-instance-2"
  machine_type = "n1-standard-1"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
 network = "default"
  }
  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
  allow_stopping_for_update = true
}


Navigate to Compute Engine > VM Instances. Click on tf-instance-1. Copy the Instance ID

Navigate to Compute Engine > VM Instances. Click on tf-instance-2. Copy the Instance ID

Run in cloud shell
terraform import module.instances.google_compute_instance.tf-instance-1 <Instance ID - 1>
terraform import module.instances.google_compute_instance.tf-instance-2 <Instance ID - 2>

terraform plan
terraform apply

-----------------------------------------------------------------------------------------------------------------------------------------------------------
Task 3. Configure a remote backend

Add the following code to the modules/storage/storage.tf file

resource "google_storage_bucket" "storage-bucket" {
  name          = "<YOUR-BUCKET>"
  location      = "US"
  force_destroy = true
  uniform_bucket_level_access = true
}


Next, add the following to the main.tf file:


module "storage" {
  source     = "./modules/storage"
}


Run cloud shell : 
terraform init
terraform apply

Next, update the main.tf

terraform {
  backend "gcs" {
    bucket  = "<REPLACE YOUR BUCKET>"
 prefix  = "terraform/state"
  }
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.53.0"
    }
  }
}

terraform init

-----------------------------------------------------------------------------------------------------------------------------------------------------------

Task 4. Modify and update infrastructure

navigate to modules/instances/instances.tf modify tf-instance-1 and tf-instance-2
add tf-instance-3


resource "google_compute_instance" "Instance Name" {
  name         = "Instance Name"
  machine_type = "e2-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
 network = "default"
  }
  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
  allow_stopping_for_update = true
}


Run cloud shell : 
terraform init
terraform apply


-----------------------------------------------------------------------------------------------------------------------------------------------------------

Task 5. Taint and destroy resources

terraform taint module.instances.google_compute_instance.Instance_name

terraform plan
terraform apply

navigate to modules/instances/instances.tf remove tf-instance-3

terraform apply



-----------------------------------------------------------------------------------------------------------------------------------------------------------

Task 6. Use a module from the Registry

In the Terraform Registry, browse to the Network Module.
Copy and paste the following into the main.tf 


module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 6.0.0"

    project_id   = "PROJECT_ID"
    network_name = "VPC_NAME"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-central1"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-central1"
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
            description           = "This subnet has a description"
        },
    ]
}



run cloud shell :
terraform init
terraform apply


-----------------------------------------------------------------------------------------------------------------------------------------------------------

Next, navigate to the instances.tf file and update the configuration resources to connect tf-instance-1 to subnet-01 and tf-instance-2 to subnet-02


resource "google_compute_instance" "tf-instance-1"{
  name         = "tf-instance-1"
  machine_type = "e2-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "VPC_NAME"
     subnetwork = "subnet-01"
  }
  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
  allow_stopping_for_update = true
}

resource "google_compute_instance" "tf-instance-2"{
  name         = "tf-instance-2"
  machine_type = "e2-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "VPC_NAME"
     subnetwork = "subnet-02"
  }

  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
  allow_stopping_for_update = true
}



module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 6.0.0"

    project_id   = "PROJECT_ID"
    network_name = "VPC_NAME"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-central1"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-central1"
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
            description           = "This subnet has a description"
        },
    ]
}



run cloud shell :
terraform init
terraform apply


-----------------------------------------------------------------------------------------------------------------------------------------------------------

Task - 6 : Configure a firewall

Add the following resource to the main.tf file and fill in the GCP Project ID:


resource "google_compute_firewall" "tf-firewall"{
  name    = "tf-firewall"
 network = "projects/<PROJECT_ID>/global/networks/VPC_Name"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["web"]
  source_ranges = ["0.0.0.0/0"]
}

run cloud shell : 
terraform init
terraform apply












