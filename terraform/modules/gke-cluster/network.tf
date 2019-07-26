resource "google_compute_network" "gke" {
  name                    = var.name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "nodes" {
  depends_on               = ["google_compute_network.gke"]
  name                     = "${var.name}-nodes"
  network                  = google_compute_network.gke.self_link
  ip_cidr_range            = var.network_config["node_cidr"]
  private_ip_google_access = true

  secondary_ip_range = [{
    range_name    = "services"
    ip_cidr_range = var.network_config["service_cidr"]
    },
    {
      range_name    = "pods"
      ip_cidr_range = var.network_config["pod_cidr"]
  }]
}

resource "google_compute_firewall" "ssh-to-gke-nodes" {
  count   = var.network_config["enable_ssh"] ? 1 : 0
  name    = "ssh-to-${var.name}-nodes"
  network = google_compute_network.gke.self_link

  target_service_accounts = [google_service_account.nodes.email]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_router" "gke_nodes" {
  count   = var.network_config["enable_natgw"] ? 1 : 0
  name    = "gke-${var.name}-nodes"
  network = google_compute_network.gke.self_link
}

resource "google_compute_router_nat" "gke_nodes" {
  count                              = var.network_config["enable_natgw"] ? 1 : 0
  name                               = "gke-${var.name}-nodes"
  router                             = google_compute_router.gke_nodes[count.index].name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

output "network" {
  value = {
    name      = google_compute_network.gke.name
    self_link = google_compute_network.gke.self_link
  }
}

output "subnetwork" {
  value = {
    name      = google_compute_subnetwork.nodes.name
    self_link = google_compute_subnetwork.nodes.self_link
  }
}
