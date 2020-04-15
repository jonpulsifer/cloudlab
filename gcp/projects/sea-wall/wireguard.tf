module "wireguard_network" {
  source        = "github.com/jonpulsifer/terraform-modules//gce-vpc"
  name          = "wireguard"
  ip_cidr_range = "172.16.0.0/28"
  external_ssh  = true
}

module "wireguard" {
  source             = "github.com/jonpulsifer/terraform-modules//gce-igm-shielded"
  name               = "wireguard"
  subnet             = module.wireguard_network.subnet.self_link
  encrypt_disk       = true
  location           = local.region
  preemptible        = true
  external_ip        = false
  can_ip_forward     = true
  enable_secure_boot = false
  image = {
    project = "ubuntu-os-cloud",
    family  = "ubuntu-1910",
  }
  cloud_init = file("../../../cloud-init/ubuntu-wireguard-server")
}

resource "google_compute_firewall" "wg" {
  name          = "wireguard-ingress"
  network       = module.wireguard_network.network.name
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  allow {
    protocol = "udp"
    ports    = ["51820"]
  }
}

