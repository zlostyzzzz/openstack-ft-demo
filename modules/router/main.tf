resource "openstack_networking_router_v2" "this" {
  name                = var.name
  external_network_id = var.external_network_id
}

resource "openstack_networking_router_interface_v2" "this" {
  router_id = openstack_networking_router_v2.this.id
  subnet_id = var.subnet_id
}
