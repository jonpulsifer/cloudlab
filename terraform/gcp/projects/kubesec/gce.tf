module "network" {
  source        = "github.com/jonpulsifer/terraform-modules//gce-vpc"
  name          = "computers"
  subnet_name   = "vms"
  ip_cidr_range = "10.1.1.0/29"
  external_ssh  = true
}

module "computers" {
  source             = "github.com/jonpulsifer/terraform-modules//gce-igm-shielded"
  name               = "cos"
  subnet             = module.network.subnet.self_link
  preemptible        = false
  encrypt_disk       = false
  enable_stackdriver = false
  location           = local.region
  external_ip        = true
  image = {
    project = "cos-cloud"
    family  = "cos-beta"
  }
  cloud_init      = file("../../../../cloud-init/cos-wordpress")
  persistent_disk = true
}

resource "google_compute_firewall" "wordpress_web" {
  name          = "wordpress-web"
  network       = module.network.network.name
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}
