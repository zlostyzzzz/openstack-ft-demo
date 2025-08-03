provider "openstack" {
  user_name     = var.user_name
  password      = var.password
  auth_url      = var.auth_url
  tenant_name   = var.tenant_name
  domain_name   = var.domain_name
  region        = var.region
}

module "network" {
  source = "../../modules/network"

  providers = {
    openstack = openstack
  }

  network_name = "web-net-dev"
  subnet_name  = "web-subnet-dev"
  cidr         = "192.168.101.0/24"
  gateway_ip   = "192.168.101.1"
  dns_servers  = ["8.8.8.8"]
}

module "security_group" {
  source = "../../modules/security_group"

  providers = {
    openstack = openstack
  }

  name        = "web-sg"
  description = "Allow SSH and HTTP"
}


module "router" {
  source = "../../modules/router"

  providers = {
    openstack = openstack
  }

  name                = "web-router"
  subnet_id           = module.network.subnet_id
  external_network_id = var.external_network_id
}

module "instance" {
  source = "../../modules/instance"

  providers = {
    openstack = openstack
  }

  name                = "web-vm"
  flavor              = "gp1-2-4"
  image               = "ubuntu_22_04"
  keypair_name        = "Website-Harsh"
  security_group_name = module.security_group.name
  network_id          = module.network.network_id
# user_data_path      = ""  # Not used
  external_network_name = var.external_network_name
  depends_on = [module.network]
}

module "provisioner" {
  source           = "../../modules/provisioner"
  instance_ips     = module.instance.instance_ips
  private_key_path = "${path.root}/Website-Harsh.pem"
  depends_on       = [module.instance]
}

module "loadbalancer" {
  source                = "../../modules/loadbalancer"
  subnet_id             = module.network.subnet_id
  vm_private_ips        = module.instance.private_ips
  external_network_name = var.external_network_name
  depends_on       = [module.provisioner]
}



