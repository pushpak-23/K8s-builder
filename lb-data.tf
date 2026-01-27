data "openstack_networking_network_v2" "external" {
  name = var.external_network
}

data "openstack_networking_subnet_v2" "external_subnet" {
  network_id = data.openstack_networking_network_v2.external.id
}

data "openstack_networking_network_v2" "internal" {
  name = var.internal_network
}

data "openstack_networking_subnet_v2" "internal_subnet" {
  network_id = data.openstack_networking_network_v2.internal.id
}
