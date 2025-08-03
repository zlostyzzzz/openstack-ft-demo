output "provisioned_instances" {
  value = [for ip in var.instance_ips : ip]
}