resource "google_compute_network" "network" {
  name = var.name

  # we dont like defaults around here
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vms" {
  provider                 = "google-beta"
  name                     = "vms"
  ip_cidr_range            = var.vm_cidr
  network                  = google_compute_network.network.self_link
  private_ip_google_access = var.private_api_access

  enable_flow_logs = var.enable_flow_logs
  # log_config {
  #   aggregation_interval = "INTERVAL_10_MIN"
  #   flow_sampling        = 0.5
  #   metadata             = "INCLUDE_ALL_METADATA"
  # }
}

output "network" {
  value = google_compute_network.network.name
}

output "subnet" {
  value = google_compute_subnetwork.vms.self_link
}

output "self_links" {
  value = {
    "network" = google_compute_network.network.self_link
    "subnet"  = google_compute_subnetwork.vms.self_link
  }
}
