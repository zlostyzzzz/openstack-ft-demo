output "name" {
  description = "Name of the security group"
  value       = openstack_networking_secgroup_v2.this.name
}
