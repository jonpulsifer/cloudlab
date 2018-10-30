resource "google_compute_firewall" "nginx" {
  name    = "nginx"
  network = "${module.network.name}"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["76.69.152.145/32"]
}

resource "google_compute_firewall" "asterisk" {
  name    = "asterisk"
  network = "${module.network.name}"

  allow {
    protocol = "tcp"
    ports    = ["5060", "5061"]
  }

  allow {
    protocol = "udp"
    ports    = ["4569", "16384-16394", "5060", "5061"]
  }

  # toronto4.voip.ms
  source_ranges = ["158.85.70.151/32"]
}
