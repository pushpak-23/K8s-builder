resource "openstack_compute_instance_v2" "master" {
  count = var.master_count
  name  = "${var.cluster_name}-master-${count.index}"

  flavor_name       = var.master_flavor
  key_pair          = var.ssh_key
  availability_zone = var.availability_zone

  security_groups = [
    openstack_networking_secgroup_v2.master_sg.name
  ]

  block_device {
    uuid                  = data.openstack_images_image_v2.image.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = var.boot_volume_size
    volume_type           = var.boot_volume_type
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    name = var.internal_network
  }

  user_data = templatefile("${path.module}/cloud-init.yaml", {
    hostname       = "${var.cluster_name}-master-${count.index}"
    username       = var.common_user
    password       = var.common_password
    ssh_public_key = var.ssh_public_key
  })

  depends_on = [
    openstack_blockstorage_volume_v3.master_vol
  ]
}

resource "openstack_compute_volume_attach_v2" "master_attach" {
  count       = var.master_count
  instance_id = openstack_compute_instance_v2.master[count.index].id
  volume_id   = openstack_blockstorage_volume_v3.master_vol[count.index].id
}
resource "openstack_compute_instance_v2" "worker" {
  count = var.worker_count
  name  = "${var.cluster_name}-worker-${count.index}"

  flavor_name       = var.worker_flavor
  key_pair          = var.ssh_key
  availability_zone = var.availability_zone

  security_groups = [
    openstack_networking_secgroup_v2.worker_sg.name
  ]

  block_device {
    uuid                  = data.openstack_images_image_v2.image.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = var.boot_volume_size
    volume_type           = var.boot_volume_type
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    name = var.internal_network
  }

  user_data = templatefile("${path.module}/cloud-init.yaml", {
    hostname       = "${var.cluster_name}-worker-${count.index}"
    username       = var.common_user
    password       = var.common_password
    ssh_public_key = var.ssh_public_key
  })

  depends_on = [
    openstack_blockstorage_volume_v3.worker_vol
  ]
}

resource "openstack_compute_volume_attach_v2" "worker_attach" {
  count       = var.worker_count
  instance_id = openstack_compute_instance_v2.worker[count.index].id
  volume_id   = openstack_blockstorage_volume_v3.worker_vol[count.index].id
}
data "openstack_images_image_v2" "image" {
  name = var.image
}
