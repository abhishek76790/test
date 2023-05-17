project_id = "demo-prj"
region = "us-central1"
simple_bucket_name = "demo-bkt-test"
location = "us-centarl1"
if_versioning_to_be_enabled = true
storage_class = "STANDARD"
user_name = "user:usr@org.com"
network_name = "vpc-demo"
standalone_vpc_routing_mode = "GLOBAL"
us_east4_subnet_name = "sb-demo-vpc-east4"
us_east4_ip_range = "10.0.0.0/20"
us_east4_region = "us-east4"
us_central1_subnet_name = "sb-demo-vpc-us-central1"
us_central1_ip_range = "10.0.9.0/20"
us_central1_region = "us-central1"
us_west1_subnet_name = "sb-demo-vpc-us-west1"
us_west1_ip_range = "10.2.0.0/20"
us_west1_region = "us-west1"
route_egress_internet = "egress-internet"
route_egress_internet_destination_range = "0.0.0.0/0"
route_egress_internet_tags = "egress-inet"
route_app_proxy = "app-proxy"
route_app_proxy_destination_range = "10.50.10.0/24"
route_app_proxy_tags = "app-proxy"
route_app_proxy_next_hop_instance_tags = "app-proxy-instance"
route_app_proxy_next_hop_instance_zone = "us-west1-a"

cloud_nat_name = "nat-vpc"
min_ports_per_vm = 64
cloud_router_name = "router-nat-demo"

machine_type = "n2-standard-4"
network_tags = ["allow-proxy"]
allow_stopping_for_update = true
deletion_protection = false
image = "os-type-public-url"
boot_disk_size_gb = "100"
boot_disk_type = "pd-balanced"
boot_disk_labels = {
    "appname" = "ngnix"
    "owner" = "gcp-admins"
}
boot_disk_auto_delete = true
attached_disk = [
    {
        source = "source_disk_uri"
    }
]
instance_network = "demo-vpc"
instance_subnetwork = "demo-vpc-sb-1"
subnetwork_project = "prj-demo"
metadata = {
    os-login = true
}
startup_script = "#bin/bash"
sa_email = "sa_project_id@gserviceaccount.com"
enable_secure_boot = true
labels = {
    "appname" = "ngnix"
    "owner" = "gcp-admins"
}

dbserver_db_name = "sql-db"
dbserver_db_version = "MYSQL_8_0"
dbserver_db_machine_type = "db-f1-micro"
dbserver_availibility_type = "ZONAL"
if_disk_autoresize = true
db_server_db_size_gb = 110
db_server_db_disk_type = "PD_SSD"
db_server_maintaince_day = 7
db_server_db_maintaince_window_update_track = "stable"
dbserver_database_flags = [
     {
     name  = "general_log"
     value = "on"
     },
     {
       name  = "log_output"
       value = "FILE"
     },
]
if_deletion_protection = true
dbserver_db_backup_configuration = {
   enabled                        = true
   binary_log_enabled             = true
   start_time                     = "17:00"
   location                       = "US"
   transaction_log_retention_days = "7"
   retained_backups               = 90
   retention_unit                 = "COUNT"
   }
secret_id = "secret-pwd-root-db"