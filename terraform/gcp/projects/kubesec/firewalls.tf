# allow SSH access to the GKE nodes
resource "google_compute_firewall" "ssh" {
  name        = "${module.gke.name}-ssh"
  network     = "${module.gke.network}"
  description = "allow SSH from the world to GKE nodes"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = ["${module.gke.node_service_account}"]
}

resource "google_compute_firewall" "workstation-ssh" {
  name        = "${module.gke.name}-workstation-ssh"
  network     = "${module.gke.network}"
  description = "allow workstation SSH from the world to GKE nodes"

  allow {
    protocol = "tcp"
    ports    = ["30022"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = ["${module.gke.node_service_account}"]
}

# allow ICMP to the GKE nodes
resource "google_compute_firewall" "icmp" {
  name        = "${module.gke.name}-icmp"
  network     = "${module.gke.network}"
  description = "allow ICMP from the world to GKE nodes"

  allow {
    protocol = "icmp"
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = ["${module.gke.node_service_account}"]
}

# Allow port 443 to the GKE nodes for nginx (lol http)
resource "google_compute_firewall" "nginx-ingress" {
  name        = "nginx-ingress-controller"
  network     = "${module.gke.network}"
  description = "allow HTTPS from the world to the nginx ingress controller"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = ["${module.gke.node_service_account}"]
}
