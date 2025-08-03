variable "subnet_id" {
  type        = string
  description = "ID of the subnet for the load balancer"
}


variable "vm_private_ips" {
  type        = list(string)
  description = "Private IPs of backend instances"
}

variable "external_network_name" {
  type        = string
  description = "External network name for floating IP"
}

# Optional (only if you still want to use `name`)
variable "name" {
  type        = string
  default     = "web-ft-lb"
  description = "Name prefix for load balancer resources"
}
