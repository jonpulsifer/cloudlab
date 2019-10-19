resource "google_project_iam_member" "cloudbuild" {
  role   = "roles/container.admin"
  member = "serviceAccount:821879192255@cloudbuild.gserviceaccount.com"
}

resource "google_service_account" "cloudlab" {
  account_id   = "cloudlab"
  display_name = "cloudlab shenanigans"
}

resource "google_project_iam_member" "cloudlab" {
  role   = "roles/browser"
  member = "serviceAccount:${google_service_account.cloudlab.email}"
}
