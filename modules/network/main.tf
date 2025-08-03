resource "openstack_networking_network_v2" "this" {
  name = var.network_name
}

resource "openstack_networking_subnet_v2" "this" {
  name            = var.subnet_name
  network_id      = openstack_networking_network_v2.this.id
  cidr            = var.cidr
  ip_version      = 4
  gateway_ip      = var.gateway_ip
  dns_nameservers = var.dns_servers
}
