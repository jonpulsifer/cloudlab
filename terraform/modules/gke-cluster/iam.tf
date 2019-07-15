# This is the GCP service account identity that your GCE instances
# will have and use for their API calls and platform operations
# https://cloud.google.com/compute/docs/access/service-accounts
resource "google_service_account" "nodes" {
  account_id   = "gke-nodes-${var.name}"
  display_name = "${var.name}'s GKE cluster node SA"
}

output "node_service_account" {
  value = google_service_account.nodes.email
}
