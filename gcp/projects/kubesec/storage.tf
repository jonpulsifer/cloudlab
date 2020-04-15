resource "google_storage_bucket" "cloud-lab" {
  name               = "cloud-lab"
  location           = "US"
  bucket_policy_only = "true"
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

data "google_iam_policy" "gcs-cloud-lab" {
  binding {
    role = "roles/storage.admin"
    members = [
      "group:cloud@pulsifer.ca",
      "serviceAccount:821879192255@cloudbuild.gserviceaccount.com",
    ]
  }

  binding {
    role = "roles/storage.objectViewer"
    members = [
      "user:alice@pulsifer.ca",
      #format("serviceAccount:%s", module.jenkins.service_account.email)
    ]
  }
}

resource "google_storage_bucket_iam_policy" "gcs-cloud-lab" {
  bucket      = google_storage_bucket.cloud-lab.name
  policy_data = data.google_iam_policy.gcs-cloud-lab.policy_data
}
