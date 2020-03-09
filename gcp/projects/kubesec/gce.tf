module "network" {
  source = "../../../../terraform-modules/gce-vpc"
  name   = "lab"
}
module "lab" {
  source             = "../../../../terraform-modules/gce-igm-shielded"
  name               = "lab"
  subnet             = module.network.self_links.subnet
  encrypt_disk       = false
  enable_stackdriver = false
  location           = local.region
  image = {
    project = "gce-uefi-images",
    family  = "ubuntu-1804-lts",
  }
}
