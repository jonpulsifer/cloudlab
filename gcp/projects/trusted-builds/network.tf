locals {
  # gce network
  vm_cidr = "172.16.1.0/29"
}

module "network" {
  source  = "../../../terraform/modules/gce-vpc"
  name    = "builds"
  vm_cidr = local.vm_cidr
}

