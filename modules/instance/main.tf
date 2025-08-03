resource "openstack_compute_servergroup_v2" "anti_affinity_group" {
  name     = "${var.name}-anti-affinity"
  policies = ["anti-affinity"]
}

resource "openstack_compute_instance_v2" "this" {
  count           = 2
  name = "${var.name}-${count.index + 1}"
  flavor_name     = var.flavor
  image_name      = var.image
  key_pair        = var.keypair_name
  security_groups = [var.security_group_name]

  network {
    uuid = var.network_id
  }

  scheduler_hints {
    group = openstack_compute_servergroup_v2.anti_affinity_group.id
  }

#  user_data = file(var.user_data_path)
}

resource "openstack_networking_floatingip_v2" "this" {
  count = 2
  pool  = var.external_network_name
}

resource "openstack_compute_floatingip_associate_v2" "this" {
  count       = 2
  floating_ip = openstack_networking_floatingip_v2.this[count.index].address
  instance_id = openstack_compute_instance_v2.this[count.index].id
}