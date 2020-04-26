resource "google_storage_bucket" "atlantis" {
  name               = "rusty-sea-can"
  location           = "NORTHAMERICA-NORTHEAST1"
  bucket_policy_only = "true"
}

data "google_iam_policy" "gcs-atlantis" {
  binding {
    role = "roles/storage.admin"
    members = [
      "group:cloud@pulsifer.ca",
      format("serviceAccount:%s", google_service_account.atlantis.email),
    ]
  }
}

resource "google_storage_bucket_iam_policy" "gcs-atlantis" {
  bucket      = google_storage_bucket.atlantis.name
  policy_data = data.google_iam_policy.gcs-atlantis.policy_data
}
