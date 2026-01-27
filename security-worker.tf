resource "openstack_networking_secgroup_v2" "worker_sg" {
  name = "${var.cluster_name}-worker-sg"
}

# SSH
resource "openstack_networking_secgroup_rule_v2" "worker_ssh" {
  security_group_id = openstack_networking_secgroup_v2.worker_sg.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  ethertype         = "IPv4"
}

# kubelet
resource "openstack_networking_secgroup_rule_v2" "worker_from_masters_10250" {
  security_group_id = openstack_networking_secgroup_v2.worker_sg.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_group_id   = openstack_networking_secgroup_v2.master_sg.id
  ethertype         = "IPv4"
}

# NodePort services
resource "openstack_networking_secgroup_rule_v2" "worker_nodeport" {
  security_group_id = openstack_networking_secgroup_v2.worker_sg.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_ip_prefix  = "0.0.0.0/0"
  ethertype         = "IPv4"
}
resource "openstack_networking_secgroup_rule_v2" "worker_internal" {
  security_group_id = openstack_networking_secgroup_v2.worker_sg.id
  direction         = "ingress"
  protocol          = null
  remote_group_id   = openstack_networking_secgroup_v2.worker_sg.id
  ethertype         = "IPv4"
}


