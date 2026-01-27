resource "openstack_lb_loadbalancer_v2" "master_lb" {
  count              = var.enable_lb && var.master_count > 1 ? 1 : 0
  name               = "${var.cluster_name}-master-lb"
  vip_subnet_id      = data.openstack_networking_subnet_v2.external_subnet.id
  security_group_ids = [openstack_networking_secgroup_v2.lb_sg.id]

  timeouts {
    create = "15m"
    delete = "15m"
  }
}

resource "openstack_lb_listener_v2" "master_listener" {
  count           = var.enable_lb && var.master_count > 1 ? 1 : 0
  name            = "${var.cluster_name}-master-listener"
  protocol        = "TCP"
  protocol_port   = 6443
  loadbalancer_id = openstack_lb_loadbalancer_v2.master_lb[0].id
}

resource "openstack_lb_pool_v2" "master_pool" {
  count       = var.enable_lb && var.master_count > 1 ? 1 : 0
  name        = "${var.cluster_name}-master-pool"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.master_listener[0].id
}

resource "openstack_lb_member_v2" "master_members" {
  count = var.enable_lb && var.master_count > 1 ? var.master_count : 0

  pool_id       = openstack_lb_pool_v2.master_pool[0].id
  address       = openstack_compute_instance_v2.master[count.index].access_ip_v4
  protocol_port = 6443
  subnet_id     = data.openstack_networking_subnet_v2.internal_subnet.id

  timeouts {
    create = "10m"
    delete = "10m"
  }
}
// Worker LoadBalancer
resource "openstack_lb_loadbalancer_v2" "worker_lb" {
  count              = var.enable_lb && var.worker_count > 1 ? 1 : 0
  name               = "${var.cluster_name}-worker-lb"
  vip_subnet_id      = data.openstack_networking_subnet_v2.external_subnet.id
  security_group_ids = [openstack_networking_secgroup_v2.lb_sg.id]

  timeouts {
    create = "15m"
    delete = "15m"
  }
}

resource "openstack_lb_listener_v2" "worker_listener" {
  count           = var.enable_lb && var.worker_count > 1 ? 1 : 0
  name            = "${var.cluster_name}-worker-listener"
  protocol        = "TCP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.worker_lb[0].id
}

resource "openstack_lb_pool_v2" "worker_pool" {
  count       = var.enable_lb && var.worker_count > 1 ? 1 : 0
  name        = "${var.cluster_name}-worker-pool"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.worker_listener[0].id
}

resource "openstack_lb_member_v2" "worker_members" {
  count = var.enable_lb && var.worker_count > 1 ? var.worker_count : 0

  pool_id       = openstack_lb_pool_v2.worker_pool[0].id
  address       = openstack_compute_instance_v2.worker[count.index].access_ip_v4
  protocol_port = 80
  subnet_id     = data.openstack_networking_subnet_v2.internal_subnet.id

  timeouts {
    create = "10m"
    delete = "10m"
  }
}
// Health Monitor 

resource "openstack_lb_monitor_v2" "master_monitor" {
  count       = var.enable_lb && var.master_count > 1 ? 1 : 0
  pool_id     = openstack_lb_pool_v2.master_pool[0].id
  type        = "TCP"
  delay       = 5
  timeout     = 3
  max_retries = 3
}

resource "openstack_lb_monitor_v2" "worker_monitor" {
  count       = var.enable_lb && var.worker_count > 1 ? 1 : 0
  pool_id     = openstack_lb_pool_v2.worker_pool[0].id
  type        = "TCP"
  delay       = 5
  timeout     = 3
  max_retries = 3
}
