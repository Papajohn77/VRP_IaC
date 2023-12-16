terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.28.0"
    }
  }
}

variable "domain_name" {}

provider "digitalocean" {}

data "digitalocean_ssh_key" "ssh_key" {
  name = "vrp-env"
}

resource "digitalocean_droplet" "vrp-env" {
  image      = "ubuntu-22-04-x64"
  name       = "vrp-env"
  region     = "fra1"
  size       = "s-1vcpu-1gb"
  monitoring = true
  ssh_keys   = [data.digitalocean_ssh_key.ssh_key.id]
}

resource "digitalocean_domain" "domain" {
  name = var.domain_name
  ip_address = digitalocean_droplet.vrp-env.ipv4_address
}

resource "digitalocean_record" "cname-record-vrp-solver" {
  domain = var.domain_name
  type   = "CNAME"
  name   = "vrp-solver"
  value  = format("%s.", var.domain_name)
  depends_on = [digitalocean_domain.domain]
}

resource "digitalocean_record" "cname-record-vrp-solver-api" {
  domain = var.domain_name
  type   = "CNAME"
  name   = "vrp-solver-api"
  value  = format("%s.", var.domain_name)
  depends_on = [digitalocean_domain.domain]
}

resource "digitalocean_record" "cname-record-pgadmin" {
  domain = var.domain_name
  type   = "CNAME"
  name   = "pgadmin"
  value  = format("%s.", var.domain_name)
  depends_on = [digitalocean_domain.domain]
}

resource "digitalocean_project" "vrp-solver-project" {
  name        = "VRP_Solver"
  purpose     = "Web Application"
  environment = "Production"
  resources   = [
    digitalocean_droplet.vrp-env.urn,
    digitalocean_domain.domain.urn
  ]
}

resource "local_file" "vrp-env-ipv4" {
  filename = "./vrp-env-ipv4"
  content = digitalocean_droplet.vrp-env.ipv4_address
}
