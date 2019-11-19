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

resource "google_service_account" "cert-manager" {
  account_id   = "cert-manager"
  display_name = "cert-manager DNS management"
}

resource "google_project_iam_member" "cert-manager" {
  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.cert-manager.email}"
}

resource "google_service_account_iam_member" "cert-manager-workload-identity" {
  service_account_id = google_service_account.cert-manager.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${data.google_client_config.current.project}.svc.id.goog[cert-manager/cert-manager]"
}

resource "google_service_account" "external-dns" {
  account_id   = "external-dns"
  display_name = "external-dns DNS management"
}

resource "google_project_iam_member" "external-dns" {
  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.external-dns.email}"
}

resource "google_service_account_iam_member" "external-dns-workload-identity" {
  service_account_id = google_service_account.external-dns.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${data.google_client_config.current.project}.svc.id.goog[external-dns/external-dns]"
}
