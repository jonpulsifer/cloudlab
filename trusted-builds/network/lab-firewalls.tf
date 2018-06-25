resource "google_compute_firewall" "ssh-to-builds" {
  name    = "ssh-to-builds"
  network = "${google_compute_network.builds.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
