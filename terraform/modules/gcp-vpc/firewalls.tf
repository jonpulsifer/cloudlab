resource "google_compute_firewall" "ssh-to-vms" {
  name    = "ssh-to-vms"
  network = "${google_compute_network.network.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
