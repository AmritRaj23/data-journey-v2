/**
 * Copyright 2022 Google LLC
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

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.31.0"
    }
  }
}

provider "google" {

}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"  
}

resource "google_compute_firewall" "vpc_network_firewall" {
  name    = "firewall"
  
  network = google_compute_network.vpc_network.name
  
  source_service_accounts = ["${google_service_account.datastream_access.email}"]

  allow {
    protocol = "tcp"
    ports    = ["12345", "12346"]
  }
}

resource "google_service_account" "datastream_access" {
  project = var.project_id
  account_id = "datastreamaccess"
  display_name = "Datastream access"
}
resource "google_project_iam_member" "datastream_admin" {
  project = var.project_id
  role = "roles/datastream.admin"
  member = "serviceAccount:${google_service_account.datastream_access.email}"
}
resource "google_sql_database_instance" "master" {    
    name = "mysql"
    database_version = "MYSQL_8_0"
    region = "us-central1"
    deletion_protection =  "false"
    settings {
        tier = "db-n1-standard-2"
        backup_configuration { 
            binary_log_enabled = true
            enabled = true
            }
        ip_configuration {
            ipv4_enabled = true
            authorized_networks { 
                name = "net1"
                value = "34.72.28.29"
            }
            authorized_networks {
                name = "net2"
                value = "34.67.234.134"
            }
            authorized_networks {
                name = "net3"
                value = "34.67.6.157"
            }
            authorized_networks {
                name = "net4"
                value = "34.72.239.218"
            }
            authorized_networks {
                name = "net5"
                value = "34.71.242.81"
            }
        }
    }
}

resource "google_sql_user" "users" {
name = "root"
instance = "${google_sql_database_instance.master.name}"
host = "%"
password = "password123"
}
resource "google_storage_bucket" "gcs_bucket" {
    name = "${var.project_id}"
    location = "us-central1" 
    force_destroy = true
}
