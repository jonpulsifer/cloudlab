resource "google_project_iam_member" "cloudservices" {
  role   = "roles/editor"
  member = "serviceAccount:${data.google_project.kubesec.number}@cloudservices.gserviceaccount.com"
}

resource "google_project_iam_member" "compute-default" {
  role   = "roles/editor"
  member = "serviceAccount:${data.google_project.kubesec.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "compute-system" {
  role   = "roles/compute.serviceAgent"
  member = "serviceAccount:service-${data.google_project.kubesec.number}@compute-system.iam.gserviceaccount.com"
}

resource "google_storage_bucket_iam_member" "cloudbuild" {
  bucket = "cloud-lab"
  role   = "roles/storage.admin"

  member = "serviceAccount:821879192255@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild" {
  role   = "roles/container.admin"
  member = "serviceAccount:821879192255@cloudbuild.gserviceaccount.com"
}

resource "google_service_account" "cert-manager" {
  account_id   = "cert-manager"
  display_name = "service account for cert-manager DNS management"
}

resource "google_project_iam_member" "cert-manager" {
  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.cert-manager.email}"
}

resource "google_service_account" "vault" {
  account_id   = "vault-server"
  display_name = "service account for vault"
}

resource "google_storage_bucket_iam_member" "vault" {
  bucket = "cloud-lab"
  role   = "roles/storage.admin"

  member = "serviceAccount:${google_service_account.vault.email}"
}
