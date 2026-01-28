output "nodes" {
  value = {
    masters = [
      for i, m in openstack_compute_instance_v2.master : {
        name        = m.name
        private_ip  = m.access_ip_v4
        floating_ip = var.assign_fip ? openstack_networking_floatingip_v2.master_fip[i].address : null
      }
    ],
    workers = [
      for i, w in openstack_compute_instance_v2.worker : {
        name        = w.name
        private_ip  = w.access_ip_v4
        floating_ip = var.assign_fip ? openstack_networking_floatingip_v2.worker_fip[i].address : null
      }
    ]
  }
}

output "k8s_api_endpoint" {
  value = (
    var.enable_lb && var.master_count > 1 && length(openstack_lb_loadbalancer_v2.master_lb) > 0
    ? "https://${openstack_lb_loadbalancer_v2.master_lb[0].vip_address}:6443"
    : "https://${openstack_compute_instance_v2.master[0].access_ip_v4}:6443"
  )
}

output "rke2_lb_host" {
  value = (
    var.enable_lb && var.master_count > 1 && length(openstack_lb_loadbalancer_v2.master_lb) > 0
    ? openstack_lb_loadbalancer_v2.master_lb[0].vip_address
    : ""
  )
}
