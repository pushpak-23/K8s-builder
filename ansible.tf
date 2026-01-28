resource "local_file" "ansible_rke2_lb" {
  count = var.enable_lb && var.master_count > 1 ? 1 : 0

  filename = "${path.root}/ansible/group_vars/terraform.auto.yml"

  content = yamlencode({
    rke2_lb_host = openstack_lb_loadbalancer_v2.master_lb[0].vip_address
  })
}
