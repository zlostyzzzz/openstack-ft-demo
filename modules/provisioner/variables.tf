variable "instance_ips" {
  type        = list(string)
  description = "List of instance IPs to provision"
}

variable "private_key_path" {
  type        = string
  description = "Path to the private SSH key for provisioning"
}


