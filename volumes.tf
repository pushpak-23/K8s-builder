resource "openstack_blockstorage_volume_v3" "master_vol" {
  count = var.master_count
  name  = "${var.cluster_name}-master-vol-${count.index}"
  size  = var.extra_volume_size
}

resource "openstack_blockstorage_volume_v3" "worker_vol" {
  count = var.worker_count
  name  = "${var.cluster_name}-worker-vol-${count.index}"
  size  = var.extra_volume_size
}
