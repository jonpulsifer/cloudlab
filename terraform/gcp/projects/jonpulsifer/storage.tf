resource "google_storage_bucket" "jonpulsifer" {
  name                        = "jonpulsifer"
  location                    = data.google_client_config.current.region
  requester_pays              = true
  force_destroy               = false
  storage_class               = "REGIONAL"
  uniform_bucket_level_access = "true"
}

data "google_iam_policy" "gcs-jonpulsifer" {
  binding {
    role = "roles/storage.admin"
    members = [
      "group:cloud@pulsifer.ca",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "gcs-jonpulsifer" {
  bucket      = google_storage_bucket.jonpulsifer.name
  policy_data = data.google_iam_policy.gcs-jonpulsifer.policy_data
}
