resource "google_storage_bucket" "sticky" {
  name               = "cloud-glue"
  location           = "NORTHAMERICA-NORTHEAST1"
  bucket_policy_only = "true"
}

data "google_iam_policy" "sticky" {
  binding {
    role = "roles/storage.admin"
    members = [
      "group:cloud@pulsifer.ca",
      format("serviceAccount:%s", google_service_account.sticky.email),
    ]
  }
}

resource "google_storage_bucket_iam_policy" "sticky" {
  bucket      = google_storage_bucket.sticky.name
  policy_data = data.google_iam_policy.sticky.policy_data
}
