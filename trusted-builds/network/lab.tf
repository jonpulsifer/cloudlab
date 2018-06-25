resource "google_compute_network" "builds" {
  name                    = "builds"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "vms" {
  name                     = "vms"
  ip_cidr_range            = "${var.gcp_config["node_cidr"]}"
  network                  = "${google_compute_network.builds.self_link}"
  region                   = "${var.gcp_config["region"]}"
  private_ip_google_access = true
}
