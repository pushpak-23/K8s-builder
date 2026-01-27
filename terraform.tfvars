cloud_name = "ocr-cluster"

cluster_name = "auto-kube"

image         = "ubuntu-server-24.04"
master_flavor = "high-performance-4vcpu-16gb-40gb"
worker_flavor = "memory-8vcpu-32gb-20gb"

master_count = 3
worker_count = 3

ssh_key           = "esec-master"
internal_network  = "ocr-cluster-net-int-10-180-1"
external_network  = "ocr-cluster-net-ext-192-168-180"
extra_volume_size = 100
availability_zone = "nova_production"
ssh_public_key    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZVJr6dWsT/cFnbvDIqut9NeAwl/n4rgMkrqS3/ds6G esec@master"
boot_volume_size  = 50
boot_volume_type  = "rbd-production"

common_user     = "kubeadmin"
common_password = "Kube@123"

