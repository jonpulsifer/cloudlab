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
