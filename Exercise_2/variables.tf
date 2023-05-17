variable "project_id" {
  description = "The ID of the project "
  type        = string
}
variable "region" {
    type = string
}

variable "simple_bucket_name" {
    type = string
}
variable "location" {
    type = string
}
variable "if_versioning_to_be_enabled" {
    type = bool
}

variable "storage_class" {
  description = "The Storage Class of the new bucket."
  type        = string
  default     = "STANDARD"
}

variable "user_name" {
   type        = string 
}

variable "network_name" {
  description = "The name of the network being created"
  type        = string
}

variable "standalone_vpc_routing_mode" {
  type        = string
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}

variable "us_east4_subnet_name"{
    type = string
}
variable "us_east4_ip_range"{
    type = string
}
variable "us_east4_region"{
    type = string
}
variable "us_central1_subnet_name"{
    type = string
}
variable "us_central1_ip_range"{
    type = string
}
variable "us_central1_region"{
    type = string
}
variable "us_west1_subnet_name"{
    type = string
}
variable "us_west1_ip_range"{
    type = string
}
variable "us_west1_region"{
    type = string
}
variable "route_egress_internet"{
    type = string
}
variable "route_egress_internet_destination_range"{
    type = string
}
variable "route_egress_internet_tags"{
    type = string
}
variable "route_app_proxy"{
    type = string
}
variable "route_app_proxy_destination_range"{
    type = string
}
variable "route_app_proxy_tags"{
    type = string
}
variable "route_app_proxy_next_hop_instance_tags"{
    type = string
}
variable "route_app_proxy_next_hop_instance_zone"{
    type = string
}


variable "cloud_nat_name" {
    type = string
}
variable "min_ports_per_vm" {
    type = number
}
variable "cloud_router_name" {
    type = string
}

variable "machine_type"{
    type = string
}
variable "network_tags"{
    type = list(string)
}
variable "allow_stopping_for_update"{
    type = string
}
variable "deletion_protection"{
    type = bool
}
variable "image"{
    type = string
}
variable "boot_disk_size_gb"{
    type = string
}
variable "boot_disk_type"{
    type = string
}
variable "boot_disk_labels"{
    type = string
}
variable "boot_disk_auto_delete"{
    type = bool
}
variable "attached_disk"{
    type = list(string)
}
variable "network"{
    type = string
}
variable "subnetwork"{
    type = string
}
variable "subnetwork_project"{
    type = string
}
variable "metadata"{
    type = map(string)
}
variable "startup_script"{
    type = string
}
variable "sa_email"{
    type = string
}
variable "enable_secure_boot"{
    type = bool
}
variable "labels"{
    type = map(string)
}


variable "dbserver_db_name" {
    type        = string
}
variable "dbserver_db_version" {
    type        = string
}
variable "dbserver_db_machine_type" {
    type        = string
}
variable "dbserver_availibility_type" {
  type        = string

}
variable "if_disk_autoresize" {
  type        = bool
}
variable "dbserver_db_size_gb" {
  type        = number
}
variable "dbserver_db_disk_type" {
  type        = string
}
variable "dbserver_maintaince_day" {
  type        = number
}
variable "dbserver_db_maintaince_window_update_track" {
  type        = string
}
variable "dbserver_database_flags" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
variable "if_deletion_protection" {
    type = bool
}
variable "dbserver_db_backup_configuration" {
  type = object({
    binary_log_enabled             = bool
    enabled                        = bool
    start_time                     = string
    location                       = string
    transaction_log_retention_days = string
    retained_backups               = number
    retention_unit                 = string
  })
  default = {
    binary_log_enabled             = false
    enabled                        = false
    start_time                     = null
    location                       = null
    transaction_log_retention_days = null
    retained_backups               = null
    retention_unit                 = null
  }

}

variable "secret_id" {
    type = string
}