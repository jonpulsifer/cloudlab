resource "google_project_iam_member" "cert-manager" {
  role   = "roles/dns.admin"
  member = "serviceAccount:cert-manager@kubesec.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "external-dns" {
  role   = "roles/dns.admin"
  member = "serviceAccount:external-dns@kubesec.iam.gserviceaccount.com"
}

resource "google_service_account" "wishlist" {
  account_id   = "wishlist"
  display_name = "Application service account"
}

resource "google_service_account_iam_member" "wishlist-workload-identity" {
  service_account_id = google_service_account.wishlist.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:kubesec.svc.id.goog[wishlist/wishlist]"
}
