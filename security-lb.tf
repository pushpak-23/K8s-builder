resource "openstack_networking_secgroup_v2" "lb_sg" {
  name = "${var.cluster_name}-lb-sg"
}
# Kubernetes API
resource "openstack_networking_secgroup_rule_v2" "lb_api" {
  security_group_id = openstack_networking_secgroup_v2.lb_sg.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = "0.0.0.0/0"
  ethertype         = "IPv4"
}

# HTTP
resource "openstack_networking_secgroup_rule_v2" "lb_http" {
  security_group_id = openstack_networking_secgroup_v2.lb_sg.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  ethertype         = "IPv4"
}

# HTTPS (optional)
resource "openstack_networking_secgroup_rule_v2" "lb_https" {
  security_group_id = openstack_networking_secgroup_v2.lb_sg.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  ethertype         = "IPv4"
}
