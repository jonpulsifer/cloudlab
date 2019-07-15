# resource "google_compute_router" "gke_nodes" {
#   name    = "gke-nodes"
#   network = module.corp.network["self_link"]
# }

# resource "google_compute_router_nat" "gke_nodes" {
#   name                               = "gke-nodes"
#   router                             = google_compute_router.gke_nodes.name
#   nat_ip_allocate_option             = "AUTO_ONLY"
#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
# }
