output "nodes" {
  value = {
    masters = [
      for i, m in openstack_compute_instance_v2.master : {
        name        = m.name
        private_ip  = m.access_ip_v4
        floating_ip = var.assign_fip ? openstack_networking_floatingip_v2.master_fip[i].address : null
      }
    ]
    workers = [
      for i, w in openstack_compute_instance_v2.worker : {
        name        = w.name
        private_ip  = w.access_ip_v4
        floating_ip = var.assign_fip ? openstack_networking_floatingip_v2.worker_fip[i].address : null
      }
    ]
  }
}
