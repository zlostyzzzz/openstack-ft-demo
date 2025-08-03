output "instance_ips" {
  value = [for fip in openstack_networking_floatingip_v2.this : fip.address]
}

output "private_ips" {
  value = [for server in openstack_compute_instance_v2.this : server.network[0].fixed_ip_v4]
}
