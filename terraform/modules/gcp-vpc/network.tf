resource "google_compute_network" "network" {
  name = "${var.name}"

  # we dont like defaults around here
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vms" {
  name                     = "vms"
  ip_cidr_range            = "${var.vm_cidr}"
  network                  = "${google_compute_network.network.self_link}"
  private_ip_google_access = "${var.private_api_access}"
}

output "subnet" {
  value = "${google_compute_subnetwork.vms.self_link}"
}
