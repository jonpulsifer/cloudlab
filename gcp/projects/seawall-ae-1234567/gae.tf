locals {
  project = "seawall-ae-1234567"
  region  = "northamerica-northeast1"
  zone    = join("-", [local.region, "b"])
  firewall_rules = {
    "github-webhook-1" = {
      action       = "ALLOW"
      source_range = "192.30.252.0/22"
      priority     = 1011
    },
    "github-webhook-2" = {
      action       = "ALLOW"
      source_range = "185.199.108.0/22"
      priority     = 1012
    },
    "github-webhook-3" = {
      action       = "ALLOW"
      source_range = "140.82.112.0/20"
      priority     = 1013
    },
    "default-tf-action" = {
      action       = "ALLOW"
      source_range = "*"
      priority     = 1337
    }
  }
  domain_names = {
    "umadbro.dev"         = {},
    "www.umadbro.dev"     = {},
    "seawall.umadbro.dev" = {}
  }
}

module "network" {
  source                  = "github.com/jonpulsifer/terraform-modules//gce-vpc"
  name                    = "default"
  auto_create_subnetworks = true # gui cheat codes
  subnet_name             = "default"
  ip_cidr_range           = "10.162.0.0/20"
  private_api_access      = false
}

module "atlantis" {
  source         = "github.com/jonpulsifer/terraform-modules//appengine-flex"
  name           = "default"
  project        = local.project
  location       = local.region
  serving_status = "SERVING"
  firewall_rules = local.firewall_rules
  domain_names   = local.domain_names
}
