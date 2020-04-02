module "network" {
  source        = "github.com/jonpulsifer/terraform-modules//gce-vpc"
  name          = "lab"
  ip_cidr_range = "172.16.0.0/28"
}

module "lab" {
  source             = "github.com/jonpulsifer/terraform-modules//gce-igm-shielded"
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
