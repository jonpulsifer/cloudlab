resource "google_compute_network" "gke" {
  name                    = "${var.name}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "nodes" {
  depends_on               = ["google_compute_network.gke"]
  name                     = "${var.name}-nodes"
  network                  = "${google_compute_network.gke.self_link}"
  ip_cidr_range            = "${var.cluster_config["node_cidr"]}"
  private_ip_google_access = "true"

  secondary_ip_range = {
    range_name    = "services"
    ip_cidr_range = "${var.cluster_config["service_cidr"]}"
  }

  secondary_ip_range = {
    range_name    = "pods"
    ip_cidr_range = "${var.cluster_config["pod_cidr"]}"
  }
}

# allow SSH access to your nodes
resource "google_compute_firewall" "ssh" {
  depends_on = [
    "google_service_account.nodes",
    "google_compute_network.gke",
  ]

  name    = "${var.name}-ssh"
  network = "${google_compute_network.gke.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = ["${google_service_account.nodes.email}"]
}

# allow ICMP to your nodes
resource "google_compute_firewall" "icmp" {
  depends_on = [
    "google_service_account.nodes",
    "google_compute_network.gke",
  ]

  name    = "${var.name}-icmp"
  network = "${google_compute_network.gke.name}"

  allow {
    protocol = "icmp"
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = ["${google_service_account.nodes.email}"]
}

resource "google_compute_firewall" "nginx-ingress" {
  name    = "nginx-ingress-controller"
  network = "${google_compute_network.gke.name}"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = ["${google_service_account.nodes.email}"]
}
