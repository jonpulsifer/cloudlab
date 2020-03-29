resource "google_storage_bucket" "homelab-ng" {
  name               = "homelab-ng"
  location           = data.google_client_config.current.region
  bucket_policy_only = "true"
  requester_pays     = true
  force_destroy      = false
  storage_class      = "REGIONAL"
}

data "google_iam_policy" "gcs-homelab-ng" {
  binding {
    role = "roles/storage.admin"
    members = [
      "group:cloud@pulsifer.ca",
      "serviceAccount:seawall-ae-1234567@appspot.gserviceaccount.com",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "gcs-homelab-ng" {
  bucket      = google_storage_bucket.homelab-ng.name
  policy_data = data.google_iam_policy.gcs-homelab-ng.policy_data
}
