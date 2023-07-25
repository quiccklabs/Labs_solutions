


gcloud services enable compute.googleapis.com --project=$DEVSHELL_PROJECT_ID

sleep 30

mkdir tfnet
cd tfnet

cat > terraform.tfstate.backup <<EOF
{
  "version": 4,
  "terraform_version": "1.5.2",
  "serial": 24,
  "lineage": "0da21a59-c5be-3bc8-9e54-18d78740f8f5",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "google_compute_firewall",
      "name": "managementnet_allow_http_ssh_rdp_icmp",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 1,
          "attributes": {
            "allow": [
              {
                "ports": [
                  "22",
                  "80",
                  "3389"
                ],
                "protocol": "tcp"
              },
              {
                "ports": [],
                "protocol": "icmp"
              }
            ],
            "creation_timestamp": "2023-07-25T06:57:18.691-07:00",
            "deny": [],
            "description": "",
            "destination_ranges": [],
            "direction": "INGRESS",
            "disabled": false,
            "enable_logging": null,
            "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/global/firewalls/managementnet-allow-http-ssh-rdp-icmp",
            "log_config": [],
            "name": "managementnet-allow-http-ssh-rdp-icmp",
            "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/managementnet",
            "priority": 1000,
            "project": "qwiklabs-gcp-04-3a00bc1b710c",
            "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/firewalls/managementnet-allow-http-ssh-rdp-icmp",
            "source_ranges": [
              "0.0.0.0/0"
            ],
            "source_service_accounts": [],
            "source_tags": [],
            "target_service_accounts": [],
            "target_tags": [],
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiMSJ9",
          "dependencies": [
            "google_compute_network.managementnet"
          ]
        }
      ]
    },
    {
      "mode": "managed",
      "type": "google_compute_firewall",
      "name": "mynetwork-allow-http-ssh-rdp-icmp",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 1,
          "attributes": {
            "allow": [
              {
                "ports": [
                  "22",
                  "80",
                  "3389"
                ],
                "protocol": "tcp"
              },
              {
                "ports": [],
                "protocol": "icmp"
              }
            ],
            "creation_timestamp": "2023-07-25T07:11:07.584-07:00",
            "deny": [],
            "description": "",
            "destination_ranges": [],
            "direction": "INGRESS",
            "disabled": false,
            "enable_logging": null,
            "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/global/firewalls/mynetwork-allow-http-ssh-rdp-icmp",
            "log_config": [],
            "name": "mynetwork-allow-http-ssh-rdp-icmp",
            "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/mynetwork",
            "priority": 1000,
            "project": "qwiklabs-gcp-04-3a00bc1b710c",
            "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/firewalls/mynetwork-allow-http-ssh-rdp-icmp",
            "source_ranges": [
              "0.0.0.0/0"
            ],
            "source_service_accounts": [],
            "source_tags": [],
            "target_service_accounts": [],
            "target_tags": [],
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiMSJ9",
          "dependencies": [
            "google_compute_network.mynetwork"
          ]
        }
      ]
    },
    {
      "mode": "managed",
      "type": "google_compute_firewall",
      "name": "privatenet-allow-http-ssh-rdp-icmp",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 1,
          "attributes": {
            "allow": [
              {
                "ports": [
                  "22",
                  "80",
                  "3389"
                ],
                "protocol": "tcp"
              },
              {
                "ports": [],
                "protocol": "icmp"
              }
            ],
            "creation_timestamp": "2023-07-25T07:02:54.003-07:00",
            "deny": [],
            "description": "",
            "destination_ranges": [],
            "direction": "INGRESS",
            "disabled": false,
            "enable_logging": null,
            "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/global/firewalls/privatenet-allow-http-ssh-rdp-icmp",
            "log_config": [],
            "name": "privatenet-allow-http-ssh-rdp-icmp",
            "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/privatenet",
            "priority": 1000,
            "project": "qwiklabs-gcp-04-3a00bc1b710c",
            "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/firewalls/privatenet-allow-http-ssh-rdp-icmp",
            "source_ranges": [
              "0.0.0.0/0"
            ],
            "source_service_accounts": [],
            "source_tags": [],
            "target_service_accounts": [],
            "target_tags": [],
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiMSJ9",
          "dependencies": [
            "google_compute_network.privatenet"
          ]
        }
      ]
    },
    {
      "mode": "managed",
      "type": "google_compute_network",
      "name": "managementnet",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "auto_create_subnetworks": false,
            "delete_default_routes_on_create": false,
            "description": "",
            "enable_ula_internal_ipv6": false,
            "gateway_ipv4": "",
            "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/managementnet",
            "internal_ipv6_range": "",
            "mtu": 0,
            "name": "managementnet",
            "network_firewall_policy_enforcement_order": "AFTER_CLASSIC_FIREWALL",
            "project": "qwiklabs-gcp-04-3a00bc1b710c",
            "routing_mode": "REGIONAL",
            "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/managementnet",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH19"
        }
      ]
    },
    {
      "mode": "managed",
      "type": "google_compute_network",
      "name": "mynetwork",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "auto_create_subnetworks": true,
            "delete_default_routes_on_create": false,
            "description": "",
            "enable_ula_internal_ipv6": false,
            "gateway_ipv4": "",
            "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/mynetwork",
            "internal_ipv6_range": "",
            "mtu": 0,
            "name": "mynetwork",
            "network_firewall_policy_enforcement_order": "AFTER_CLASSIC_FIREWALL",
            "project": "qwiklabs-gcp-04-3a00bc1b710c",
            "routing_mode": "REGIONAL",
            "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/mynetwork",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH19"
        }
      ]
    },
    {
      "mode": "managed",
      "type": "google_compute_network",
      "name": "privatenet",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "auto_create_subnetworks": false,
            "delete_default_routes_on_create": false,
            "description": "",
            "enable_ula_internal_ipv6": false,
            "gateway_ipv4": "",
            "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/privatenet",
            "internal_ipv6_range": "",
            "mtu": 0,
            "name": "privatenet",
            "network_firewall_policy_enforcement_order": "AFTER_CLASSIC_FIREWALL",
            "project": "qwiklabs-gcp-04-3a00bc1b710c",
            "routing_mode": "REGIONAL",
            "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/privatenet",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH19"
        }
      ]
    },
    {
      "mode": "managed",
      "type": "google_compute_subnetwork",
      "name": "managementsubnet-us",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "creation_timestamp": "2023-07-25T06:57:20.467-07:00",
            "description": "",
            "external_ipv6_prefix": "",
            "fingerprint": null,
            "gateway_address": "10.130.0.1",
            "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_1/subnetworks/managementsubnet-us",
            "ip_cidr_range": "10.130.0.0/20",
            "ipv6_access_type": "",
            "ipv6_cidr_range": "",
            "log_config": [],
            "name": "managementsubnet-us",
            "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/managementnet",
            "private_ip_google_access": false,
            "private_ipv6_google_access": "DISABLE_GOOGLE_ACCESS",
            "project": "qwiklabs-gcp-04-3a00bc1b710c",
            "purpose": "PRIVATE",
            "region": "$REGION_1",
            "role": "",
            "secondary_ip_range": [],
            "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_1/subnetworks/managementsubnet-us",
            "stack_type": "IPV4_ONLY",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH19",
          "dependencies": [
            "google_compute_network.managementnet"
          ]
        }
      ]
    },
    {
      "mode": "managed",
      "type": "google_compute_subnetwork",
      "name": "privatesubnet-second-subnet",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "creation_timestamp": "2023-07-25T07:02:55.686-07:00",
            "description": "",
            "external_ipv6_prefix": "",
            "fingerprint": null,
            "gateway_address": "172.20.0.1",
            "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_2/subnetworks/privatesubnet-second-subnet",
            "ip_cidr_range": "172.20.0.0/24",
            "ipv6_access_type": "",
            "ipv6_cidr_range": "",
            "log_config": [],
            "name": "privatesubnet-second-subnet",
            "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/privatenet",
            "private_ip_google_access": false,
            "private_ipv6_google_access": "DISABLE_GOOGLE_ACCESS",
            "project": "qwiklabs-gcp-04-3a00bc1b710c",
            "purpose": "PRIVATE",
            "region": "$REGION_2",
            "role": "",
            "secondary_ip_range": [],
            "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_2/subnetworks/privatesubnet-second-subnet",
            "stack_type": "IPV4_ONLY",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH19",
          "dependencies": [
            "google_compute_network.privatenet"
          ]
        }
      ]
    },
    {
      "mode": "managed",
      "type": "google_compute_subnetwork",
      "name": "privatesubnet-us",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "creation_timestamp": "2023-07-25T07:02:55.118-07:00",
            "description": "",
            "external_ipv6_prefix": "",
            "fingerprint": null,
            "gateway_address": "172.16.0.1",
            "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_1/subnetworks/privatesubnet-us",
            "ip_cidr_range": "172.16.0.0/24",
            "ipv6_access_type": "",
            "ipv6_cidr_range": "",
            "log_config": [],
            "name": "privatesubnet-us",
            "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/privatenet",
            "private_ip_google_access": false,
            "private_ipv6_google_access": "DISABLE_GOOGLE_ACCESS",
            "project": "qwiklabs-gcp-04-3a00bc1b710c",
            "purpose": "PRIVATE",
            "region": "$REGION_1",
            "role": "",
            "secondary_ip_range": [],
            "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_1/subnetworks/privatesubnet-us",
            "stack_type": "IPV4_ONLY",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH19",
          "dependencies": [
            "google_compute_network.privatenet"
          ]
        }
      ]
    },
    {
      "module": "module.managementnet-us-vm",
      "mode": "managed",
      "type": "google_compute_instance",
      "name": "vm_instance",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 6,
          "attributes": {
            "advanced_machine_features": [],
            "allow_stopping_for_update": null,
            "attached_disk": [],
            "boot_disk": [
              {
                "auto_delete": true,
                "device_name": "persistent-disk-0",
                "disk_encryption_key_raw": "",
                "disk_encryption_key_sha256": "",
                "initialize_params": [
                  {
                    "image": "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-11-bullseye-v20230711",
                    "labels": {},
                    "resource_manager_tags": {},
                    "size": 10,
                    "type": "pd-standard"
                  }
                ],
                "kms_key_self_link": "",
                "mode": "READ_WRITE",
                "source": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/disks/managementnet-us-vm"
              }
            ],
            "can_ip_forward": false,
            "confidential_instance_config": [],
            "cpu_platform": "Intel Haswell",
            "current_status": "RUNNING",
            "deletion_protection": false,
            "description": "",
            "desired_status": null,
            "enable_display": false,
            "guest_accelerator": [],
            "hostname": "",
            "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/instances/managementnet-us-vm",
            "instance_id": "3633495322825747006",
            "label_fingerprint": "42WmSpB8rSM=",
            "labels": {},
            "machine_type": "n1-standard-1",
            "metadata": {},
            "metadata_fingerprint": "8tOkcZFWcCk=",
            "metadata_startup_script": null,
            "min_cpu_platform": "",
            "name": "managementnet-us-vm",
            "network_interface": [
              {
                "access_config": [
                  {
                    "nat_ip": "34.122.156.46",
                    "network_tier": "PREMIUM",
                    "public_ptr_domain_name": ""
                  }
                ],
                "alias_ip_range": [],
                "ipv6_access_config": [],
                "ipv6_access_type": "",
                "name": "nic0",
                "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/managementnet",
                "network_ip": "10.130.0.2",
                "nic_type": "",
                "queue_count": 0,
                "stack_type": "IPV4_ONLY",
                "subnetwork": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_1/subnetworks/managementsubnet-us",
                "subnetwork_project": "qwiklabs-gcp-04-3a00bc1b710c"
              }
            ],
            "network_performance_config": [],
            "params": [],
            "project": "qwiklabs-gcp-04-3a00bc1b710c",
            "reservation_affinity": [],
            "resource_policies": [],
            "scheduling": [
              {
                "automatic_restart": true,
                "instance_termination_action": "",
                "min_node_cpus": 0,
                "node_affinities": [],
                "on_host_maintenance": "MIGRATE",
                "preemptible": false,
                "provisioning_model": "STANDARD"
              }
            ],
            "scratch_disk": [],
            "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/instances/managementnet-us-vm",
            "service_account": [],
            "shielded_instance_config": [
              {
                "enable_integrity_monitoring": true,
                "enable_secure_boot": false,
                "enable_vtpm": true
              }
            ],
            "tags": [],
            "tags_fingerprint": "42WmSpB8rSM=",
            "timeouts": null,
            "zone": "$ZONE_1"
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiNiJ9",
          "dependencies": [
            "google_compute_subnetwork.managementsubnet-us"
          ]
        }
      ]
    },
    {
      "module": "module.mynet-second-vm",
      "mode": "managed",
      "type": "google_compute_instance",
      "name": "vm_instance",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 6,
          "attributes": {
            "advanced_machine_features": [],
            "allow_stopping_for_update": null,
            "attached_disk": [],
            "boot_disk": [
              {
                "auto_delete": true,
                "device_name": "persistent-disk-0",
                "disk_encryption_key_raw": "",
                "disk_encryption_key_sha256": "",
                "initialize_params": [
                  {
                    "image": "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-11-bullseye-v20230711",
                    "labels": {},
                    "resource_manager_tags": null,
                    "size": 10,
                    "type": "pd-standard"
                  }
                ],
                "kms_key_self_link": "",
                "mode": "READ_WRITE",
                "source": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_2/disks/mynet-second-vm"
              }
            ],
            "can_ip_forward": false,
            "confidential_instance_config": [],
            "cpu_platform": "Intel Broadwell",
            "current_status": "RUNNING",
            "deletion_protection": false,
            "description": "",
            "desired_status": null,
            "enable_display": false,
            "guest_accelerator": [],
            "hostname": "",
            "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_2/instances/mynet-second-vm",
            "instance_id": "5001211865642198375",
            "label_fingerprint": "42WmSpB8rSM=",
            "labels": null,
            "machine_type": "e2-micro",
            "metadata": null,
            "metadata_fingerprint": "8tOkcZFWcCk=",
            "metadata_startup_script": null,
            "min_cpu_platform": "",
            "name": "mynet-second-vm",
            "network_interface": [
              {
                "access_config": [
                  {
                    "nat_ip": "34.127.26.207",
                    "network_tier": "PREMIUM",
                    "public_ptr_domain_name": ""
                  }
                ],
                "alias_ip_range": [],
                "ipv6_access_config": [],
                "ipv6_access_type": "",
                "name": "nic0",
                "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/mynetwork",
                "network_ip": "10.138.0.2",
                "nic_type": "",
                "queue_count": 0,
                "stack_type": "IPV4_ONLY",
                "subnetwork": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_2/subnetworks/mynetwork",
                "subnetwork_project": "qwiklabs-gcp-04-3a00bc1b710c"
              }
            ],
            "network_performance_config": [],
            "params": [],
            "project": "qwiklabs-gcp-04-3a00bc1b710c",
            "reservation_affinity": [],
            "resource_policies": null,
            "scheduling": [
              {
                "automatic_restart": true,
                "instance_termination_action": "",
                "min_node_cpus": 0,
                "node_affinities": [],
                "on_host_maintenance": "MIGRATE",
                "preemptible": false,
                "provisioning_model": "STANDARD"
              }
            ],
            "scratch_disk": [],
            "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_2/instances/mynet-second-vm",
            "service_account": [],
            "shielded_instance_config": [
              {
                "enable_integrity_monitoring": true,
                "enable_secure_boot": false,
                "enable_vtpm": true
              }
            ],
            "tags": null,
            "tags_fingerprint": "42WmSpB8rSM=",
            "timeouts": null,
            "zone": "$ZONE_2"
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiNiJ9",
          "dependencies": [
            "google_compute_network.mynetwork"
          ]
        }
      ]
    },
    {
      "module": "module.mynet-us-vm",
      "mode": "managed",
      "type": "google_compute_instance",
      "name": "vm_instance",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 6,
          "attributes": {
            "advanced_machine_features": [],
            "allow_stopping_for_update": null,
            "attached_disk": [],
            "boot_disk": [
              {
                "auto_delete": true,
                "device_name": "persistent-disk-0",
                "disk_encryption_key_raw": "",
                "disk_encryption_key_sha256": "",
                "initialize_params": [
                  {
                    "image": "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-11-bullseye-v20230711",
                    "labels": {},
                    "resource_manager_tags": {},
                    "size": 10,
                    "type": "pd-standard"
                  }
                ],
                "kms_key_self_link": "",
                "mode": "READ_WRITE",
                "source": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/disks/mynet-us-vm"
              }
            ],
            "can_ip_forward": false,
            "confidential_instance_config": [],
            "cpu_platform": "Intel Haswell",
            "current_status": "RUNNING",
            "deletion_protection": false,
            "description": "",
            "desired_status": null,
            "enable_display": false,
            "guest_accelerator": [],
            "hostname": "",
            "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/instances/mynet-us-vm",
            "instance_id": "1123860900010420498",
            "label_fingerprint": "42WmSpB8rSM=",
            "labels": {},
            "machine_type": "n1-standard-1",
            "metadata": {},
            "metadata_fingerprint": "8tOkcZFWcCk=",
            "metadata_startup_script": null,
            "min_cpu_platform": "",
            "name": "mynet-us-vm",
            "network_interface": [
              {
                "access_config": [
                  {
                    "nat_ip": "34.67.14.59",
                    "network_tier": "PREMIUM",
                    "public_ptr_domain_name": ""
                  }
                ],
                "alias_ip_range": [],
                "ipv6_access_config": [],
                "ipv6_access_type": "",
                "name": "nic0",
                "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/mynetwork",
                "network_ip": "10.128.0.2",
                "nic_type": "",
                "queue_count": 0,
                "stack_type": "IPV4_ONLY",
                "subnetwork": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_1/subnetworks/mynetwork",
                "subnetwork_project": "qwiklabs-gcp-04-3a00bc1b710c"
              }
            ],
            "network_performance_config": [],
            "params": [],
            "project": "qwiklabs-gcp-04-3a00bc1b710c",
            "reservation_affinity": [],
            "resource_policies": [],
            "scheduling": [
              {
                "automatic_restart": true,
                "instance_termination_action": "",
                "min_node_cpus": 0,
                "node_affinities": [],
                "on_host_maintenance": "MIGRATE",
                "preemptible": false,
                "provisioning_model": "STANDARD"
              }
            ],
            "scratch_disk": [],
            "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/instances/mynet-us-vm",
            "service_account": [],
            "shielded_instance_config": [
              {
                "enable_integrity_monitoring": true,
                "enable_secure_boot": false,
                "enable_vtpm": true
              }
            ],
            "tags": [],
            "tags_fingerprint": "42WmSpB8rSM=",
            "timeouts": null,
            "zone": "$ZONE_1"
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiNiJ9",
          "dependencies": [
            "google_compute_network.mynetwork"
          ]
        }
      ]
    },
    {
      "module": "module.privatenet-us-vm",
      "mode": "managed",
      "type": "google_compute_instance",
      "name": "vm_instance",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 6,
          "attributes": {
            "advanced_machine_features": [],
            "allow_stopping_for_update": null,
            "attached_disk": [],
            "boot_disk": [
              {
                "auto_delete": true,
                "device_name": "persistent-disk-0",
                "disk_encryption_key_raw": "",
                "disk_encryption_key_sha256": "",
                "initialize_params": [
                  {
                    "image": "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-11-bullseye-v20230711",
                    "labels": {},
                    "resource_manager_tags": {},
                    "size": 10,
                    "type": "pd-standard"
                  }
                ],
                "kms_key_self_link": "",
                "mode": "READ_WRITE",
                "source": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/disks/privatenet-us-vm"
              }
            ],
            "can_ip_forward": false,
            "confidential_instance_config": [],
            "cpu_platform": "Intel Haswell",
            "current_status": "RUNNING",
            "deletion_protection": false,
            "description": "",
            "desired_status": null,
            "enable_display": false,
            "guest_accelerator": [],
            "hostname": "",
            "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/instances/privatenet-us-vm",
            "instance_id": "8802976255882455280",
            "label_fingerprint": "42WmSpB8rSM=",
            "labels": {},
            "machine_type": "n1-standard-1",
            "metadata": {},
            "metadata_fingerprint": "8tOkcZFWcCk=",
            "metadata_startup_script": null,
            "min_cpu_platform": "",
            "name": "privatenet-us-vm",
            "network_interface": [
              {
                "access_config": [
                  {
                    "nat_ip": "34.67.168.32",
                    "network_tier": "PREMIUM",
                    "public_ptr_domain_name": ""
                  }
                ],
                "alias_ip_range": [],
                "ipv6_access_config": [],
                "ipv6_access_type": "",
                "name": "nic0",
                "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/privatenet",
                "network_ip": "172.16.0.2",
                "nic_type": "",
                "queue_count": 0,
                "stack_type": "IPV4_ONLY",
                "subnetwork": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_1/subnetworks/privatesubnet-us",
                "subnetwork_project": "qwiklabs-gcp-04-3a00bc1b710c"
              }
            ],
            "network_performance_config": [],
            "params": [],
            "project": "qwiklabs-gcp-04-3a00bc1b710c",
            "reservation_affinity": [],
            "resource_policies": [],
            "scheduling": [
              {
                "automatic_restart": true,
                "instance_termination_action": "",
                "min_node_cpus": 0,
                "node_affinities": [],
                "on_host_maintenance": "MIGRATE",
                "preemptible": false,
                "provisioning_model": "STANDARD"
              }
            ],
            "scratch_disk": [],
            "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/instances/privatenet-us-vm",
            "service_account": [],
            "shielded_instance_config": [
              {
                "enable_integrity_monitoring": true,
                "enable_secure_boot": false,
                "enable_vtpm": true
              }
            ],
            "tags": [],
            "tags_fingerprint": "42WmSpB8rSM=",
            "timeouts": null,
            "zone": "$ZONE_1"
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiNiJ9",
          "dependencies": [
            "google_compute_subnetwork.privatesubnet-us"
          ]
        }
      ]
    }
  ],
  "check_results": null
}

EOF




cat > terraform.tfstate <<EOF
{
    "version": 4,
    "terraform_version": "1.5.2",
    "serial": 29,
    "lineage": "0da21a59-c5be-3bc8-9e54-18d78740f8f5",
    "outputs": {},
    "resources": [
      {
        "mode": "managed",
        "type": "google_compute_firewall",
        "name": "managementnet_allow_http_ssh_rdp_icmp",
        "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
        "instances": [
          {
            "schema_version": 1,
            "attributes": {
              "allow": [
                {
                  "ports": [
                    "22",
                    "80",
                    "3389"
                  ],
                  "protocol": "tcp"
                },
                {
                  "ports": [],
                  "protocol": "icmp"
                }
              ],
              "creation_timestamp": "2023-07-25T06:57:18.691-07:00",
              "deny": [],
              "description": "",
              "destination_ranges": [],
              "direction": "INGRESS",
              "disabled": false,
              "enable_logging": null,
              "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/global/firewalls/managementnet-allow-http-ssh-rdp-icmp",
              "log_config": [],
              "name": "managementnet-allow-http-ssh-rdp-icmp",
              "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/managementnet",
              "priority": 1000,
              "project": "qwiklabs-gcp-04-3a00bc1b710c",
              "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/firewalls/managementnet-allow-http-ssh-rdp-icmp",
              "source_ranges": [
                "0.0.0.0/0"
              ],
              "source_service_accounts": [],
              "source_tags": [],
              "target_service_accounts": [],
              "target_tags": [],
              "timeouts": null
            },
            "sensitive_attributes": [],
            "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiMSJ9",
            "dependencies": [
              "google_compute_network.managementnet"
            ]
          }
        ]
      },
      {
        "mode": "managed",
        "type": "google_compute_firewall",
        "name": "mynetwork-allow-http-ssh-rdp-icmp",
        "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
        "instances": [
          {
            "schema_version": 1,
            "attributes": {
              "allow": [
                {
                  "ports": [
                    "22",
                    "80",
                    "3389"
                  ],
                  "protocol": "tcp"
                },
                {
                  "ports": [],
                  "protocol": "icmp"
                }
              ],
              "creation_timestamp": "2023-07-25T07:11:07.584-07:00",
              "deny": [],
              "description": "",
              "destination_ranges": [],
              "direction": "INGRESS",
              "disabled": false,
              "enable_logging": null,
              "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/global/firewalls/mynetwork-allow-http-ssh-rdp-icmp",
              "log_config": [],
              "name": "mynetwork-allow-http-ssh-rdp-icmp",
              "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/mynetwork",
              "priority": 1000,
              "project": "qwiklabs-gcp-04-3a00bc1b710c",
              "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/firewalls/mynetwork-allow-http-ssh-rdp-icmp",
              "source_ranges": [
                "0.0.0.0/0"
              ],
              "source_service_accounts": [],
              "source_tags": [],
              "target_service_accounts": [],
              "target_tags": [],
              "timeouts": null
            },
            "sensitive_attributes": [],
            "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiMSJ9",
            "dependencies": [
              "google_compute_network.mynetwork"
            ]
          }
        ]
      },
      {
        "mode": "managed",
        "type": "google_compute_firewall",
        "name": "privatenet-allow-http-ssh-rdp-icmp",
        "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
        "instances": [
          {
            "schema_version": 1,
            "attributes": {
              "allow": [
                {
                  "ports": [
                    "22",
                    "80",
                    "3389"
                  ],
                  "protocol": "tcp"
                },
                {
                  "ports": [],
                  "protocol": "icmp"
                }
              ],
              "creation_timestamp": "2023-07-25T07:02:54.003-07:00",
              "deny": [],
              "description": "",
              "destination_ranges": [],
              "direction": "INGRESS",
              "disabled": false,
              "enable_logging": null,
              "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/global/firewalls/privatenet-allow-http-ssh-rdp-icmp",
              "log_config": [],
              "name": "privatenet-allow-http-ssh-rdp-icmp",
              "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/privatenet",
              "priority": 1000,
              "project": "qwiklabs-gcp-04-3a00bc1b710c",
              "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/firewalls/privatenet-allow-http-ssh-rdp-icmp",
              "source_ranges": [
                "0.0.0.0/0"
              ],
              "source_service_accounts": [],
              "source_tags": [],
              "target_service_accounts": [],
              "target_tags": [],
              "timeouts": null
            },
            "sensitive_attributes": [],
            "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiMSJ9",
            "dependencies": [
              "google_compute_network.privatenet"
            ]
          }
        ]
      },
      {
        "mode": "managed",
        "type": "google_compute_network",
        "name": "managementnet",
        "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
        "instances": [
          {
            "schema_version": 0,
            "attributes": {
              "auto_create_subnetworks": false,
              "delete_default_routes_on_create": false,
              "description": "",
              "enable_ula_internal_ipv6": false,
              "gateway_ipv4": "",
              "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/managementnet",
              "internal_ipv6_range": "",
              "mtu": 0,
              "name": "managementnet",
              "network_firewall_policy_enforcement_order": "AFTER_CLASSIC_FIREWALL",
              "project": "qwiklabs-gcp-04-3a00bc1b710c",
              "routing_mode": "REGIONAL",
              "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/managementnet",
              "timeouts": null
            },
            "sensitive_attributes": [],
            "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH19"
          }
        ]
      },
      {
        "mode": "managed",
        "type": "google_compute_network",
        "name": "mynetwork",
        "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
        "instances": [
          {
            "schema_version": 0,
            "attributes": {
              "auto_create_subnetworks": true,
              "delete_default_routes_on_create": false,
              "description": "",
              "enable_ula_internal_ipv6": false,
              "gateway_ipv4": "",
              "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/mynetwork",
              "internal_ipv6_range": "",
              "mtu": 0,
              "name": "mynetwork",
              "network_firewall_policy_enforcement_order": "AFTER_CLASSIC_FIREWALL",
              "project": "qwiklabs-gcp-04-3a00bc1b710c",
              "routing_mode": "REGIONAL",
              "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/mynetwork",
              "timeouts": null
            },
            "sensitive_attributes": [],
            "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH19"
          }
        ]
      },
      {
        "mode": "managed",
        "type": "google_compute_network",
        "name": "privatenet",
        "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
        "instances": [
          {
            "schema_version": 0,
            "attributes": {
              "auto_create_subnetworks": false,
              "delete_default_routes_on_create": false,
              "description": "",
              "enable_ula_internal_ipv6": false,
              "gateway_ipv4": "",
              "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/privatenet",
              "internal_ipv6_range": "",
              "mtu": 0,
              "name": "privatenet",
              "network_firewall_policy_enforcement_order": "AFTER_CLASSIC_FIREWALL",
              "project": "qwiklabs-gcp-04-3a00bc1b710c",
              "routing_mode": "REGIONAL",
              "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/privatenet",
              "timeouts": null
            },
            "sensitive_attributes": [],
            "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH19"
          }
        ]
      },
      {
        "mode": "managed",
        "type": "google_compute_subnetwork",
        "name": "managementsubnet-us",
        "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
        "instances": [
          {
            "schema_version": 0,
            "attributes": {
              "creation_timestamp": "2023-07-25T06:57:20.467-07:00",
              "description": "",
              "external_ipv6_prefix": "",
              "fingerprint": null,
              "gateway_address": "10.130.0.1",
              "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_1/subnetworks/managementsubnet-us",
              "ip_cidr_range": "10.130.0.0/20",
              "ipv6_access_type": "",
              "ipv6_cidr_range": "",
              "log_config": [],
              "name": "managementsubnet-us",
              "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/managementnet",
              "private_ip_google_access": false,
              "private_ipv6_google_access": "DISABLE_GOOGLE_ACCESS",
              "project": "qwiklabs-gcp-04-3a00bc1b710c",
              "purpose": "PRIVATE",
              "region": "$REGION_1",
              "role": "",
              "secondary_ip_range": [],
              "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_1/subnetworks/managementsubnet-us",
              "stack_type": "IPV4_ONLY",
              "timeouts": null
            },
            "sensitive_attributes": [],
            "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH19",
            "dependencies": [
              "google_compute_network.managementnet"
            ]
          }
        ]
      },
      {
        "mode": "managed",
        "type": "google_compute_subnetwork",
        "name": "privatesubnet-second-subnet",
        "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
        "instances": [
          {
            "schema_version": 0,
            "attributes": {
              "creation_timestamp": "2023-07-25T07:02:55.686-07:00",
              "description": "",
              "external_ipv6_prefix": "",
              "fingerprint": null,
              "gateway_address": "172.20.0.1",
              "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_2/subnetworks/privatesubnet-second-subnet",
              "ip_cidr_range": "172.20.0.0/24",
              "ipv6_access_type": "",
              "ipv6_cidr_range": "",
              "log_config": [],
              "name": "privatesubnet-second-subnet",
              "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/privatenet",
              "private_ip_google_access": false,
              "private_ipv6_google_access": "DISABLE_GOOGLE_ACCESS",
              "project": "qwiklabs-gcp-04-3a00bc1b710c",
              "purpose": "PRIVATE",
              "region": "$REGION_2",
              "role": "",
              "secondary_ip_range": [],
              "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_2/subnetworks/privatesubnet-second-subnet",
              "stack_type": "IPV4_ONLY",
              "timeouts": null
            },
            "sensitive_attributes": [],
            "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH19",
            "dependencies": [
              "google_compute_network.privatenet"
            ]
          }
        ]
      },
      {
        "mode": "managed",
        "type": "google_compute_subnetwork",
        "name": "privatesubnet-us",
        "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
        "instances": [
          {
            "schema_version": 0,
            "attributes": {
              "creation_timestamp": "2023-07-25T07:02:55.118-07:00",
              "description": "",
              "external_ipv6_prefix": "",
              "fingerprint": null,
              "gateway_address": "172.16.0.1",
              "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_1/subnetworks/privatesubnet-us",
              "ip_cidr_range": "172.16.0.0/24",
              "ipv6_access_type": "",
              "ipv6_cidr_range": "",
              "log_config": [],
              "name": "privatesubnet-us",
              "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/privatenet",
              "private_ip_google_access": false,
              "private_ipv6_google_access": "DISABLE_GOOGLE_ACCESS",
              "project": "qwiklabs-gcp-04-3a00bc1b710c",
              "purpose": "PRIVATE",
              "region": "$REGION_1",
              "role": "",
              "secondary_ip_range": [],
              "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_1/subnetworks/privatesubnet-us",
              "stack_type": "IPV4_ONLY",
              "timeouts": null
            },
            "sensitive_attributes": [],
            "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH19",
            "dependencies": [
              "google_compute_network.privatenet"
            ]
          }
        ]
      },
      {
        "module": "module.managementnet-us-vm",
        "mode": "managed",
        "type": "google_compute_instance",
        "name": "vm_instance",
        "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
        "instances": [
          {
            "schema_version": 6,
            "attributes": {
              "advanced_machine_features": [],
              "allow_stopping_for_update": null,
              "attached_disk": [],
              "boot_disk": [
                {
                  "auto_delete": true,
                  "device_name": "persistent-disk-0",
                  "disk_encryption_key_raw": "",
                  "disk_encryption_key_sha256": "",
                  "initialize_params": [
                    {
                      "image": "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-11-bullseye-v20230711",
                      "labels": {},
                      "resource_manager_tags": {},
                      "size": 10,
                      "type": "pd-standard"
                    }
                  ],
                  "kms_key_self_link": "",
                  "mode": "READ_WRITE",
                  "source": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/disks/managementnet-us-vm"
                }
              ],
              "can_ip_forward": false,
              "confidential_instance_config": [],
              "cpu_platform": "Intel Haswell",
              "current_status": "RUNNING",
              "deletion_protection": false,
              "description": "",
              "desired_status": null,
              "enable_display": false,
              "guest_accelerator": [],
              "hostname": "",
              "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/instances/managementnet-us-vm",
              "instance_id": "3633495322825747006",
              "label_fingerprint": "42WmSpB8rSM=",
              "labels": {},
              "machine_type": "n1-standard-1",
              "metadata": {},
              "metadata_fingerprint": "8tOkcZFWcCk=",
              "metadata_startup_script": null,
              "min_cpu_platform": "",
              "name": "managementnet-us-vm",
              "network_interface": [
                {
                  "access_config": [
                    {
                      "nat_ip": "34.122.156.46",
                      "network_tier": "PREMIUM",
                      "public_ptr_domain_name": ""
                    }
                  ],
                  "alias_ip_range": [],
                  "ipv6_access_config": [],
                  "ipv6_access_type": "",
                  "name": "nic0",
                  "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/managementnet",
                  "network_ip": "10.130.0.2",
                  "nic_type": "",
                  "queue_count": 0,
                  "stack_type": "IPV4_ONLY",
                  "subnetwork": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_1/subnetworks/managementsubnet-us",
                  "subnetwork_project": "qwiklabs-gcp-04-3a00bc1b710c"
                }
              ],
              "network_performance_config": [],
              "params": [],
              "project": "qwiklabs-gcp-04-3a00bc1b710c",
              "reservation_affinity": [],
              "resource_policies": [],
              "scheduling": [
                {
                  "automatic_restart": true,
                  "instance_termination_action": "",
                  "min_node_cpus": 0,
                  "node_affinities": [],
                  "on_host_maintenance": "MIGRATE",
                  "preemptible": false,
                  "provisioning_model": "STANDARD"
                }
              ],
              "scratch_disk": [],
              "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/instances/managementnet-us-vm",
              "service_account": [],
              "shielded_instance_config": [
                {
                  "enable_integrity_monitoring": true,
                  "enable_secure_boot": false,
                  "enable_vtpm": true
                }
              ],
              "tags": [],
              "tags_fingerprint": "42WmSpB8rSM=",
              "timeouts": null,
              "zone": "$ZONE_1"
            },
            "sensitive_attributes": [],
            "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiNiJ9",
            "dependencies": [
              "google_compute_subnetwork.managementsubnet-us"
            ]
          }
        ]
      },
      {
        "module": "module.mynet-second-vm",
        "mode": "managed",
        "type": "google_compute_instance",
        "name": "vm_instance",
        "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
        "instances": [
          {
            "schema_version": 6,
            "attributes": {
              "advanced_machine_features": [],
              "allow_stopping_for_update": null,
              "attached_disk": [],
              "boot_disk": [
                {
                  "auto_delete": true,
                  "device_name": "persistent-disk-0",
                  "disk_encryption_key_raw": "",
                  "disk_encryption_key_sha256": "",
                  "initialize_params": [
                    {
                      "image": "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-11-bullseye-v20230711",
                      "labels": {},
                      "resource_manager_tags": {},
                      "size": 10,
                      "type": "pd-standard"
                    }
                  ],
                  "kms_key_self_link": "",
                  "mode": "READ_WRITE",
                  "source": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_2/disks/mynet-second-vm"
                }
              ],
              "can_ip_forward": false,
              "confidential_instance_config": [],
              "cpu_platform": "Intel Broadwell",
              "current_status": "RUNNING",
              "deletion_protection": false,
              "description": "",
              "desired_status": null,
              "enable_display": false,
              "guest_accelerator": [],
              "hostname": "",
              "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_2/instances/mynet-second-vm",
              "instance_id": "5001211865642198375",
              "label_fingerprint": "42WmSpB8rSM=",
              "labels": {},
              "machine_type": "e2-micro",
              "metadata": {},
              "metadata_fingerprint": "8tOkcZFWcCk=",
              "metadata_startup_script": null,
              "min_cpu_platform": "",
              "name": "mynet-second-vm",
              "network_interface": [
                {
                  "access_config": [
                    {
                      "nat_ip": "34.127.26.207",
                      "network_tier": "PREMIUM",
                      "public_ptr_domain_name": ""
                    }
                  ],
                  "alias_ip_range": [],
                  "ipv6_access_config": [],
                  "ipv6_access_type": "",
                  "name": "nic0",
                  "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/mynetwork",
                  "network_ip": "10.138.0.2",
                  "nic_type": "",
                  "queue_count": 0,
                  "stack_type": "IPV4_ONLY",
                  "subnetwork": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_2/subnetworks/mynetwork",
                  "subnetwork_project": "qwiklabs-gcp-04-3a00bc1b710c"
                }
              ],
              "network_performance_config": [],
              "params": [],
              "project": "qwiklabs-gcp-04-3a00bc1b710c",
              "reservation_affinity": [],
              "resource_policies": [],
              "scheduling": [
                {
                  "automatic_restart": true,
                  "instance_termination_action": "",
                  "min_node_cpus": 0,
                  "node_affinities": [],
                  "on_host_maintenance": "MIGRATE",
                  "preemptible": false,
                  "provisioning_model": "STANDARD"
                }
              ],
              "scratch_disk": [],
              "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_2/instances/mynet-second-vm",
              "service_account": [],
              "shielded_instance_config": [
                {
                  "enable_integrity_monitoring": true,
                  "enable_secure_boot": false,
                  "enable_vtpm": true
                }
              ],
              "tags": [],
              "tags_fingerprint": "42WmSpB8rSM=",
              "timeouts": null,
              "zone": "$ZONE_2"
            },
            "sensitive_attributes": [],
            "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiNiJ9",
            "dependencies": [
              "google_compute_network.mynetwork"
            ]
          }
        ]
      },
      {
        "module": "module.mynet-us-vm",
        "mode": "managed",
        "type": "google_compute_instance",
        "name": "vm_instance",
        "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
        "instances": [
          {
            "schema_version": 6,
            "attributes": {
              "advanced_machine_features": [],
              "allow_stopping_for_update": null,
              "attached_disk": [],
              "boot_disk": [
                {
                  "auto_delete": true,
                  "device_name": "persistent-disk-0",
                  "disk_encryption_key_raw": "",
                  "disk_encryption_key_sha256": "",
                  "initialize_params": [
                    {
                      "image": "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-11-bullseye-v20230711",
                      "labels": {},
                      "resource_manager_tags": {},
                      "size": 10,
                      "type": "pd-standard"
                    }
                  ],
                  "kms_key_self_link": "",
                  "mode": "READ_WRITE",
                  "source": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/disks/mynet-us-vm"
                }
              ],
              "can_ip_forward": false,
              "confidential_instance_config": [],
              "cpu_platform": "Intel Haswell",
              "current_status": "RUNNING",
              "deletion_protection": false,
              "description": "",
              "desired_status": null,
              "enable_display": false,
              "guest_accelerator": [],
              "hostname": "",
              "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/instances/mynet-us-vm",
              "instance_id": "1123860900010420498",
              "label_fingerprint": "42WmSpB8rSM=",
              "labels": {},
              "machine_type": "n1-standard-1",
              "metadata": {},
              "metadata_fingerprint": "8tOkcZFWcCk=",
              "metadata_startup_script": null,
              "min_cpu_platform": "",
              "name": "mynet-us-vm",
              "network_interface": [
                {
                  "access_config": [
                    {
                      "nat_ip": "34.67.14.59",
                      "network_tier": "PREMIUM",
                      "public_ptr_domain_name": ""
                    }
                  ],
                  "alias_ip_range": [],
                  "ipv6_access_config": [],
                  "ipv6_access_type": "",
                  "name": "nic0",
                  "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/mynetwork",
                  "network_ip": "10.128.0.2",
                  "nic_type": "",
                  "queue_count": 0,
                  "stack_type": "IPV4_ONLY",
                  "subnetwork": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_1/subnetworks/mynetwork",
                  "subnetwork_project": "qwiklabs-gcp-04-3a00bc1b710c"
                }
              ],
              "network_performance_config": [],
              "params": [],
              "project": "qwiklabs-gcp-04-3a00bc1b710c",
              "reservation_affinity": [],
              "resource_policies": [],
              "scheduling": [
                {
                  "automatic_restart": true,
                  "instance_termination_action": "",
                  "min_node_cpus": 0,
                  "node_affinities": [],
                  "on_host_maintenance": "MIGRATE",
                  "preemptible": false,
                  "provisioning_model": "STANDARD"
                }
              ],
              "scratch_disk": [],
              "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/instances/mynet-us-vm",
              "service_account": [],
              "shielded_instance_config": [
                {
                  "enable_integrity_monitoring": true,
                  "enable_secure_boot": false,
                  "enable_vtpm": true
                }
              ],
              "tags": [],
              "tags_fingerprint": "42WmSpB8rSM=",
              "timeouts": null,
              "zone": "$ZONE_1"
            },
            "sensitive_attributes": [],
            "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiNiJ9",
            "dependencies": [
              "google_compute_network.mynetwork"
            ]
          }
        ]
      },
      {
        "module": "module.privatenet-us-vm",
        "mode": "managed",
        "type": "google_compute_instance",
        "name": "vm_instance",
        "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
        "instances": [
          {
            "schema_version": 6,
            "attributes": {
              "advanced_machine_features": [],
              "allow_stopping_for_update": null,
              "attached_disk": [],
              "boot_disk": [
                {
                  "auto_delete": true,
                  "device_name": "persistent-disk-0",
                  "disk_encryption_key_raw": "",
                  "disk_encryption_key_sha256": "",
                  "initialize_params": [
                    {
                      "image": "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-11-bullseye-v20230711",
                      "labels": {},
                      "resource_manager_tags": {},
                      "size": 10,
                      "type": "pd-standard"
                    }
                  ],
                  "kms_key_self_link": "",
                  "mode": "READ_WRITE",
                  "source": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/disks/privatenet-us-vm"
                }
              ],
              "can_ip_forward": false,
              "confidential_instance_config": [],
              "cpu_platform": "Intel Haswell",
              "current_status": "RUNNING",
              "deletion_protection": false,
              "description": "",
              "desired_status": null,
              "enable_display": false,
              "guest_accelerator": [],
              "hostname": "",
              "id": "projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/instances/privatenet-us-vm",
              "instance_id": "8802976255882455280",
              "label_fingerprint": "42WmSpB8rSM=",
              "labels": {},
              "machine_type": "n1-standard-1",
              "metadata": {},
              "metadata_fingerprint": "8tOkcZFWcCk=",
              "metadata_startup_script": null,
              "min_cpu_platform": "",
              "name": "privatenet-us-vm",
              "network_interface": [
                {
                  "access_config": [
                    {
                      "nat_ip": "34.67.168.32",
                      "network_tier": "PREMIUM",
                      "public_ptr_domain_name": ""
                    }
                  ],
                  "alias_ip_range": [],
                  "ipv6_access_config": [],
                  "ipv6_access_type": "",
                  "name": "nic0",
                  "network": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/global/networks/privatenet",
                  "network_ip": "172.16.0.2",
                  "nic_type": "",
                  "queue_count": 0,
                  "stack_type": "IPV4_ONLY",
                  "subnetwork": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/regions/$REGION_1/subnetworks/privatesubnet-us",
                  "subnetwork_project": "qwiklabs-gcp-04-3a00bc1b710c"
                }
              ],
              "network_performance_config": [],
              "params": [],
              "project": "qwiklabs-gcp-04-3a00bc1b710c",
              "reservation_affinity": [],
              "resource_policies": [],
              "scheduling": [
                {
                  "automatic_restart": true,
                  "instance_termination_action": "",
                  "min_node_cpus": 0,
                  "node_affinities": [],
                  "on_host_maintenance": "MIGRATE",
                  "preemptible": false,
                  "provisioning_model": "STANDARD"
                }
              ],
              "scratch_disk": [],
              "self_link": "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-04-3a00bc1b710c/zones/$ZONE_1/instances/privatenet-us-vm",
              "service_account": [],
              "shielded_instance_config": [
                {
                  "enable_integrity_monitoring": true,
                  "enable_secure_boot": false,
                  "enable_vtpm": true
                }
              ],
              "tags": [],
              "tags_fingerprint": "42WmSpB8rSM=",
              "timeouts": null,
              "zone": "$ZONE_1"
            },
            "sensitive_attributes": [],
            "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiNiJ9",
            "dependencies": [
              "google_compute_subnetwork.privatesubnet-us"
            ]
          }
        ]
      }
    ],
    "check_results": null
  }
  
EOF



cat > provider.tf <<EOF
provider "google" {}
EOF


cat > privatenet.tf <<EOF
# Create privatenet network
resource "google_compute_network" "privatenet" {
  name                    = "privatenet"
  auto_create_subnetworks = false
}



# Create privatesubnet-us subnetwork
resource "google_compute_subnetwork" "privatesubnet-us" {
  name          = "privatesubnet-us"
  region        = "$REGION_1"
  network       = google_compute_network.privatenet.self_link
  ip_cidr_range = "172.16.0.0/24"
}

# Create privatesubnet-second-subnet subnetwork
resource "google_compute_subnetwork" "privatesubnet-second-subnet" {
  name          = "privatesubnet-second-subnet"
  region        = "$REGION_2"
  network       = google_compute_network.privatenet.self_link
  ip_cidr_range = "172.20.0.0/24"
}

# Create a firewall rule to allow HTTP, SSH, RDP and ICMP traffic on privatenet
resource "google_compute_firewall" "privatenet-allow-http-ssh-rdp-icmp" {
  name = "privatenet-allow-http-ssh-rdp-icmp"
  source_ranges = [
    "0.0.0.0/0"
  ]
  network = google_compute_network.privatenet.self_link
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
  allow {
    protocol = "icmp"
  }
}

# Add the privatenet-us-vm instance
module "privatenet-us-vm" {
  source              = "./instance"
  instance_name       = "privatenet-us-vm"
  instance_zone       = "$ZONE_1"
  instance_subnetwork = google_compute_subnetwork.privatesubnet-us.self_link
}
EOF


cat > mynetwork.tf <<EOF
# Create the mynetwork network
resource "google_compute_network" "mynetwork" {
  name                    = "mynetwork"
  auto_create_subnetworks = true
}

# Create a firewall rule to allow HTTP, SSH, RDP and ICMP traffic on mynetwork
resource "google_compute_firewall" "mynetwork-allow-http-ssh-rdp-icmp" {
  name = "mynetwork-allow-http-ssh-rdp-icmp"
  source_ranges = [
    "0.0.0.0/0"
  ]
  network = google_compute_network.mynetwork.self_link
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
  
  allow {
    protocol = "icmp"
  }


}

# Create the mynet-us-vm instance
module "mynet-us-vm" {
  source              = "./instance"
  instance_name       = "mynet-us-vm"
  instance_zone       = "$ZONE_1"
  instance_subnetwork = google_compute_network.mynetwork.self_link
}
# Create the mynet-second-vm instance
module "mynet-second-vm" {
  source              = "./instance"
  instance_name       = "mynet-second-vm"
  instance_zone       = "$ZONE_2"  # subscribe to quicklab
  instance_subnetwork = google_compute_network.mynetwork.self_link
}

EOF


cat > managementnet.tf <<EOF
# Create managementnet network
resource "google_compute_network" "managementnet" {
  name                    = "managementnet"
  auto_create_subnetworks = false
}

# Create managementsubnet-us subnetwork
resource "google_compute_subnetwork" "managementsubnet-us" {
  name          = "managementsubnet-us"
  region        = "$REGION_1"
  network       = google_compute_network.managementnet.self_link
  ip_cidr_range = "10.130.0.0/20"
}

# Create a firewall rule to allow HTTP, SSH, RDP and ICMP traffic on managementnet
resource "google_compute_firewall" "managementnet_allow_http_ssh_rdp_icmp" {
  name = "managementnet-allow-http-ssh-rdp-icmp"
  source_ranges = [
    "0.0.0.0/0"
  ]
  network = google_compute_network.managementnet.self_link
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
  allow {
    protocol = "icmp"
  }
}
# Add the managementnet-us-vm instance
module "managementnet-us-vm" {
  source              = "./instance"
  instance_name       = "managementnet-us-vm"
  instance_zone       = "$ZONE_1"
  instance_subnetwork = google_compute_subnetwork.managementsubnet-us.self_link
}
EOF



mkdir instance

cd instance

cat > main.tf <<EOF
variable "instance_name" {}
variable "instance_zone" {}
variable "instance_type" {
  default = "e2-medium"
}
variable "instance_subnetwork" {}

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
    subnetwork = var.instance_subnetwork
    access_config {
      # Allocate a one-to-one NAT IP to the instance
    }
  }
}
EOF

cd ..

terraform fmt

terraform init

terraform plan

terraform apply -auto-approve
