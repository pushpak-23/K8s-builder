variable "cloud_name" {}

variable "cluster_name" {}

variable "image" {}
variable "master_flavor" {}
variable "worker_flavor" {}

variable "master_count" { default = 1 }
variable "worker_count" { default = 2 }

variable "ssh_key" {}
variable "ssh_public_key" {}
variable "internal_network" {}
variable "external_network" {}

variable "extra_volume_size" { default = 50 }

variable "assign_fip" { default = true }
variable "availability_zone" {}
variable "boot_volume_size" { default = 40 }
variable "boot_volume_type" {}
variable "common_user" {}
variable "common_password" {}
variable "enable_lb" { default = true }
