module "master" {
  name         = "master"
  source       = "./modules/al_server"
  datacenter   = "nbg1-dc3"
  hcloud_token = var.hcloud_token
  ssh_keys     = data.hcloud_ssh_keys.admin.ssh_keys.*.name
  secrets      = local.secrets
  master = {
    enabled = true
  }
}

module "eu_1_server" {
  name         = "EU-I"
  source       = "./modules/al_server"
  datacenter   = "nbg1-dc3"
  hcloud_token = var.hcloud_token
  ssh_keys     = data.hcloud_ssh_keys.admin.ssh_keys.*.name
  secrets      = local.secrets
  server = {
    enabled = true
    region  = "EU"
    name    = "I"
  }
}

module "us_1_server" {
  name         = "US-I"
  source       = "./modules/al_server"
  datacenter   = "hil-dc1"
  hcloud_token = var.hcloud_token
  ssh_keys     = data.hcloud_ssh_keys.admin.ssh_keys.*.name
  secrets      = local.secrets
  server = {
    enabled = true
    region  = "US"
    name    = "I"
  }
}


output "ips" {
  value = local.ips
}

data "hcloud_ssh_keys" "admin" {
  with_selector = "role=admin"
}

locals {
  secrets = {
    base_url      = var.base_url
    keyword       = random_string.keyword.result
    master        = random_string.master.result
    server_master = random_string.server_master.result
    bot_key       = random_string.bot_key.result
  }
  ips = [
    module.us_1_server.instance_ip,
    module.eu_1_server.instance_ip,
    module.master.instance_ip,
  ]
}