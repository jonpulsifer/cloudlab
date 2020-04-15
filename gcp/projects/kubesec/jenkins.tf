module "jenkins_network" {
  source        = "github.com/jonpulsifer/terraform-modules//gce-vpc"
  name          = "jenkins"
  ip_cidr_range = "172.16.0.0/28"
  external_ssh  = true
}

module "jenkins" {
  source       = "github.com/jonpulsifer/terraform-modules//gce-igm-shielded"
  name         = "jenkins"
  subnet       = module.jenkins_network.subnet.self_link
  encrypt_disk = false
  location     = local.region
  preemptible  = true
  external_ip  = true
  image = {
    project = "gce-uefi-images",
    family  = "ubuntu-1804-lts",
  }
  cloud_init = file("../../../cloud-init/ubuntu-jenkins-server")
}

resource "google_compute_firewall" "web" {
  name          = "jenkins-ingress"
  network       = module.jenkins_network.network.name
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}

