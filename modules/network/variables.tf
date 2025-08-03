variable "network_name" {
  description = "Name of the network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "cidr" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "gateway_ip" {
  description = "Gateway IP for the subnet"
  type        = string
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
}
