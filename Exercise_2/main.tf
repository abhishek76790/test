# Exercise 2 (GCP) :
# Terraform Code to create the below Infrastructure: 
# 1	Create a GCP storage bucket
# 2	Apply a policy to the bucket allowing only read access
# 3	Create 1 VPC
# 4	Create 1 Internet gateway
# 5	Create 3 subnets
# 6	Create security groups for each subnet
# 7	Create separate default route for each subnet
# 8	Create 2 web server instance
# 9	Create 1 database server instance

###########################################################################




provider "google" {
}
provider "google-beta" {
}


#1.	Create a GCP storage bucket
module "simple_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "3.2.0"
  name       = var.simple_bucket_name
  project_id = var.project_id
  location   = var.location
  versioning = var.if_versioning_to_be_enabled
  bucket_policy_only = true
  storage_class = var.storage_class
  iam_members = []
}

# 2.	Apply a policy to the bucket allowing only read access

module "storage_bucket-iam-bindings" {
  source          = "terraform-google-modules/iam/google//modules/storage_buckets_iam"
  storage_buckets = [var.simple_bucket_name]
  mode            = "additive"
  bindings = {
    "roles/storage.legacyBucketReader" = [
      var.user_name,
    ]
    "roles/storage.objectViewer" = [
      var.user_name,
    ]
  }
}

# 3.	Create 1 VPC

module "standalone_vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "5.1.0"
  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = var.standalone_vpc_routing_mode
  subnets = [
    {
      subnet_name           = var.us_east4_subnet_name
      subnet_ip             = var.us_east4_ip_range
      subnet_region         = var.us_east4_region
      subnet_private_access = true
      subnet_flow_logs      = true
    },
    {
      subnet_name           = var.us_central1_subnet_name
      subnet_ip             = var.us_central1_ip_range
      subnet_region         = var.us_central1_region
      subnet_private_access = true
      subnet_flow_logs      = true
    },
    {
      subnet_name           = var.us_west1_subnet_name
      subnet_ip             = var.us_west1_ip_range
      subnet_region         = var.us_west1_region
      subnet_private_access = true
      subnet_flow_logs      = true
    },
  ]
  routes = [
        {
            name                   = var.route_egress_internet
            description            = "route through IGW to access internet"
            destination_range      = var.route_egress_internet_destination_range
            tags                   = var.route_egress_internet_tags
            next_hop_internet      = "true"
        },
        {
            name                   = var.route_app_proxy
            description            = "route through proxy to reach app"
            destination_range      = var.route_app_proxy_destination_range
            tags                   = var.route_app_proxy_tags
            next_hop_instance      = var.route_app_proxy_next_hop_instance_tags
            next_hop_instance_zone = var.route_app_proxy_next_hop_instance_zone
        },
    ]
}

#4.	Create 1 Internet gateway

module "cloud_nat" {
  source                              = "terraform-google-modules/cloud-nat/google"
  version                             = "2.2.1"
  name                                = var.cloud_nat_name
  project_id                          = var.project_id
  region                              = var.region
  router                              = module.cloud_router_nat.router.name
  min_ports_per_vm                    = var.min_ports_per_vm
  source_subnetwork_ip_ranges_to_nat  = var.source_subnetwork_ip_ranges_to_nat
  enable_endpoint_independent_mapping = false
  nat_ips                             = module.cloud_nat_external_static_ip_reserve.self_links
}


module "cloud_router_nat" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "3.0.0"
  name    = var.cloud_router_name
  project = var.project_id
  region  = var.region
  network = module.standalone_vpc.network_name
}

module "cloud_nat_external_static_ip_reserve" {
  source       = "terraform-google-modules/address/google"
  version      = "3.1.1"
  project_id   = var.project_id
  region       = var.region
  address_type = "EXTERNAL"
  names = [
    "nat-us-east4-1",
    "nat-us-east4-2",
    "nat-us-east4-3"
  ]
  enable_cloud_dns = false
}

# 5.	Create 3 subnets

# covered this question as part of question 3 

#6. 	Create security groups for each subnet
# In GCP we have firewall rules which works same way as security groups in AWS

module "firewall" {
  source                  = "terraform-google-modules/network/google//modules/fabric-net-firewall"
  version                 = "5.1.0"
  project_id              = var.project_id
  network                 = module.standalone_vpc.network_name
  internal_ranges_enabled = false
  internal_ranges         = []
  internal_target_tags    = []
  ssh_source_ranges       = []
  ssh_target_tags         = []
  https_target_tags       = []
  https_source_ranges     = []
  http_source_ranges      = []
  custom_rules = {
    fw-65000-egress-deny-all = {
      description          = "Override default allow all ports egress rule"
      direction            = "EGRESS"
      action               = "deny"
      ranges               = ["X.X.X"]
      use_service_accounts = false
      rules = [
        {
          protocol = "all"
          ports    = []
        }
      ]
      sources = []
      targets = []
      extra_attributes = {
        priority           = 65000
        flow_logs          = true
        flow_logs_metadata = "INCLUDE_ALL_METADATA"
      }
    }

    fw-egress-allow-all = {
      description          = "Allows for internal VPC communication"
      direction            = "EGRESS"
      action               = "allow"
      ranges               = [X.X.X.X/X]
      use_service_accounts = false
      rules = [
        {
          protocol = "all"
          ports    = []
        }
      ]
      sources = []
      targets = []
      extra_attributes = {
        priority           = 1000
        flow_logs          = true
        flow_logs_metadata = "INCLUDE_ALL_METADATA"
      }
    }

    fw-egress-allow-all-onprem-ssh-icmp-dns = {
      description = "Allows all ssh, icmp and dns traffic to onprem"
      direction   = "EGRESS"
      action      = "allow"
      ranges = []
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = ["22", "53"]
        },
        {
          protocol = "icmp"
          ports    = []
        },
      ]
      sources = []
      targets = []
      extra_attributes = {
        priority           = 1000
        flow_logs          = true
        flow_logs_metadata = "INCLUDE_ALL_METADATA"
      }
    }
}
}

#6.	Create security groups for each subnet
# In GCP we have routes at VPC level unlike security groups at in AWS

#covered this question as part of question3 see routes in the module block

# 8	Create 2 web server instance


resource "google_compute_instance" "web_server" {
  project                   = var.project_id
  count                     = 2
  name                      = var.instance_name[count.index]
  machine_type              = var.machine_type
  zone                      = var.zone
  tags                      = var.network_tags
  allow_stopping_for_update = var.allow_stopping_for_update
  deletion_protection       = var.deletion_protection
  boot_disk {
    initialize_params {
      image = var.image
      size  = var.boot_disk_size_gb
      type  = var.boot_disk_type
      labels  = var.boot_disk_labels
    }
    auto_delete = var.boot_disk_auto_delete
  }

  dynamic "attached_disk" {
    for_each = var.attached_disk
    content {
      source = lookup(attached_disk.value, "source", null)
    }
  }
  network_interface {
    network            = var.network
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project
  }
  metadata                = var.metadata
  metadata_startup_script = var.startup_script

  service_account {
      email  = var.sa_email
      scopes = "cloud-platform"
    }


  shielded_instance_config {
    enable_secure_boot = var.enable_secure_boot
  }
  labels = var.labels


}






#9. 	Create 1 database server instance

module "sql_dbserver_db" {
  source           = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  version          = "10.0.1"
  project_id       = var.project_id
  name             = var.dbserver_db_name
  database_version = var.dbserver_db_version
  region = var.region
  zone   = var.zone

  tier              = var.dbserver_db_machine_type
  availability_type = var.dbserver_availibility_type
  disk_autoresize = var.if_disk_autoresize
  disk_size       = var.dbserver_db_size_gb
  disk_type       = var.dbserver_db_disk_type
  maintenance_window_day          = var.dbserver_maintaince_day
  maintenance_window_update_track = var.dbserver_db_maintaince_window_update_track
  database_flags = var.dbserver_database_flags
  deletion_protection = var.if_deletion_protection
  backup_configuration = var.dbserver_db_backup_configuration
  ip_configuration = {
    ipv4_enabled        = false
    require_ssl         = true
    private_network     = module.standalone_vpc.self_link
    authorized_networks = []
    allocated_ip_range = null
  }
  user_name     = "root"
  user_password = data.google_secret_manager_secret_version.dbserver_db_root_pwd.secret
}


data "google_secret_manager_secret_version" "dbserver_db_root_pwd"{
  secret = google_secret_manager_secret.secret-basic.secret_id
}


resource "google_secret_manager_secret" "secret-basic" {
  project                   = var.project_id
  secret_id = var.secret_id
    replication {
    user_managed {
      replicas {
        location = var.us_west1_region
      }
      replicas {
        location = var.us_central1_region
      }
    }
  }
}
