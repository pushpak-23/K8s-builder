data "openstack_networking_port_v2" "master_port" {
  count      = var.master_count
  device_id  = openstack_compute_instance_v2.master[count.index].id
  network_id = data.openstack_networking_network_v2.internal.id
}
data "openstack_networking_port_v2" "worker_port" {
  count      = var.worker_count
  device_id  = openstack_compute_instance_v2.worker[count.index].id
  network_id = data.openstack_networking_network_v2.internal.id
}
