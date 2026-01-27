resource "openstack_networking_secgroup_v2" "master_sg" {
  name = "${var.cluster_name}-master-sg"
}


# SSH
resource "openstack_networking_secgroup_rule_v2" "master_ssh" {
  security_group_id = openstack_networking_secgroup_v2.master_sg.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  ethertype         = "IPv4"
}

# Kubernetes API (clients / LB)
resource "openstack_networking_secgroup_rule_v2" "master_api" {
  security_group_id = openstack_networking_secgroup_v2.master_sg.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = "0.0.0.0/0"
  ethertype         = "IPv4"
}

resource "openstack_networking_secgroup_rule_v2" "master_from_workers_9345" {
  security_group_id = openstack_networking_secgroup_v2.master_sg.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 9345
  port_range_max    = 9345
  remote_group_id   = openstack_networking_secgroup_v2.worker_sg.id
  ethertype         = "IPv4"
}


# etcd — ONLY from masters
resource "openstack_networking_secgroup_rule_v2" "master_etcd" {
  security_group_id = openstack_networking_secgroup_v2.master_sg.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 2379
  port_range_max    = 2380
  remote_group_id   = openstack_networking_secgroup_v2.master_sg.id
  ethertype         = "IPv4"
}

# kubelet
resource "openstack_networking_secgroup_rule_v2" "master_kubelet" {
  security_group_id = openstack_networking_secgroup_v2.master_sg.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10252
  remote_group_id   = openstack_networking_secgroup_v2.master_sg.id
  ethertype         = "IPv4"
}
resource "openstack_networking_secgroup_rule_v2" "cluster_internal" {
  security_group_id = openstack_networking_secgroup_v2.master_sg.id
  direction         = "ingress"
  protocol          = null
  remote_group_id   = openstack_networking_secgroup_v2.master_sg.id
  ethertype         = "IPv4"
}
resource "openstack_networking_secgroup_rule_v2" "master_from_workers_6443" {
  security_group_id = openstack_networking_secgroup_v2.master_sg.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_group_id   = openstack_networking_secgroup_v2.worker_sg.id
  ethertype         = "IPv4"
}


