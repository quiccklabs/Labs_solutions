/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# # Create the network
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.0"

  # Give the network a name and project
  project_id   = google_project_service.compute.project
  network_name = "my-custom-network"

  subnets = [
    {
      # Creates your first subnet in us-west1 and defines a range for it
      subnet_name   = "my-first-subnet"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-west1"
    },
    {
      # Creates a dedicated subnet for GKE
      subnet_name   = "my-gke-subnet"
      subnet_ip     = "10.10.20.0/24"
      subnet_region = "us-west1"
    },
    # Add your subnet here
    {
      subnet_name   = "my-third-subnet"
      subnet_ip     = "10.10.30.0/24"
      subnet_region = "$REGION"
    },
  ]

  # Define secondary ranges for each of your subnets
  secondary_ranges = {
    my-first-subnet = []

    my-gke-subnet = [
      {
        # Define a secondary range for Kubernetes pods to use
        range_name    = "my-gke-pods-range"
        ip_cidr_range = "192.168.64.0/24"
      },
    ]
    # Add your subnet’s secondary range below this line.
    my-third-subnet = []
  }
}
