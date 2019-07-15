resource "google_storage_bucket" "cloud-lab" {
  name               = "cloud-lab"
  location           = "US"
  bucket_policy_only = "true"
}

data "google_iam_policy" "gcs-cloud-lab" {
  binding {
    role = "roles/storage.admin"
    members = [
      "group:cloud@pulsifer.ca",
      "serviceAccount:821879192255@cloudbuild.gserviceaccount.com",
      "serviceAccount:${module.vault-igm.service_account}",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "gcs-cloud-lab" {
  bucket      = google_storage_bucket.cloud-lab.name
  policy_data = "${data.google_iam_policy.gcs-cloud-lab.policy_data}"
}
