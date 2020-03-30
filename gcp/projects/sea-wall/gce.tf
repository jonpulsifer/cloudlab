module "network" {
  source = "github.com/jonpulsifer/terraform-modules//gce-vpc"
  name   = "atlantis"
}

module "atlantis" {
  source             = "github.com/jonpulsifer/terraform-modules//gce-igm-shielded"
  name               = "atlantis"
  subnet             = module.network.self_links.subnet
  encrypt_disk       = false
  enable_stackdriver = false
  location           = local.region
  image = {
    project = "gce-uefi-images",
    family  = "cos-beta",
  }
}
