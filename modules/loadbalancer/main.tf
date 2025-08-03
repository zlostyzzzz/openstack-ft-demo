resource "openstack_lb_loadbalancer_v2" "this" {
  name          = "web-ft-lb"
  vip_subnet_id = var.subnet_id
}

resource "openstack_lb_listener_v2" "this" {
  name            = "web-ft-listener"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.this.id
}

resource "openstack_lb_pool_v2" "this" {
  name        = "web-ft-pool"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.this.id
}

resource "openstack_lb_member_v2" "member1" {
  pool_id       = openstack_lb_pool_v2.this.id
  address       = var.vm_private_ips[0]
  protocol_port = 80
  subnet_id     = var.subnet_id
}

resource "openstack_lb_member_v2" "member2" {
  pool_id       = openstack_lb_pool_v2.this.id
  address       = var.vm_private_ips[1]
  protocol_port = 80
  subnet_id     = var.subnet_id
}

resource "openstack_networking_floatingip_v2" "this" {
  pool = var.external_network_name
}

resource "openstack_networking_floatingip_associate_v2" "this" {
  floating_ip = openstack_networking_floatingip_v2.this.address
  port_id     = openstack_lb_loadbalancer_v2.this.vip_port_id
}
