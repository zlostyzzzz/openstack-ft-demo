variable "name" {
  description = "Name of the router"
  type        = string
}

variable "external_network_id" {
  description = "The ID of the external/public network"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the internal subnet to connect to the router"
  type        = string
}
