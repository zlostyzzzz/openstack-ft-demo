variable "user_name" {}
variable "password" {}
variable "auth_url" {}
variable "tenant_name" {}
variable "domain_name" {}
variable "region" {}
variable "external_network_id" {}
variable "external_network_name" {}
variable "private_key_path" {
  type        = string
  description = "Path to the private SSH key for provisioning"
}
#variable "subnet_id" {
#  type        = string
#  description = "Subnet ID for load balancer"
#}

