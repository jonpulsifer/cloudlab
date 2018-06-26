resource "google_compute_firewall" "ssh-to-lab" {
  name    = "ssh-to-lab"
  network = "${google_compute_network.lab.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
