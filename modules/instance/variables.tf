variable "name" {
  description = "Name of the instance"
  type        = string
}

variable "flavor" {
  description = "Flavor to use for the instance"
  type        = string
}

variable "image" {
  description = "Name of the image to use"
  type        = string
}

variable "keypair_name" {
  description = "Name of the keypair to use"
  type        = string
}

variable "security_group_name" {
  description = "Name of the security group to attach"
  type        = string
}

variable "network_id" {
  description = "UUID of the network to attach the instance to"
  type        = string
}

variable "external_network_name" {
  description = "Name of the external network for Floating IP"
  type        = string
}


#variable "user_data_path" {
#  description = "Path to the cloud-init config file"
#  type        = string
#}
