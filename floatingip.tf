resource "openstack_networking_floatingip_v2" "master_fip" {
  count = var.assign_fip ? var.master_count : 0
  pool  = var.external_network # must be NAME, not UUID
}

resource "openstack_networking_floatingip_associate_v2" "master_assoc" {
  count       = var.assign_fip ? var.master_count : 0
  floating_ip = openstack_networking_floatingip_v2.master_fip[count.index].address
  port_id     = data.openstack_networking_port_v2.master_port[count.index].id

  depends_on = [
    openstack_compute_instance_v2.master
  ]
}
resource "openstack_networking_floatingip_v2" "worker_fip" {
  count = var.assign_fip ? var.worker_count : 0
  pool  = var.external_network
}

resource "openstack_networking_floatingip_associate_v2" "worker_assoc" {
  count       = var.assign_fip ? var.worker_count : 0
  floating_ip = openstack_networking_floatingip_v2.worker_fip[count.index].address
  port_id     = data.openstack_networking_port_v2.worker_port[count.index].id

  depends_on = [
    openstack_compute_instance_v2.worker
  ]
}
