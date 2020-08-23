resource "google_project_iam_member" "cert_manager" {
  project = "homelab-ng"
  role    = "roles/dns.admin"
  member  = join(":", ["serviceAccount", google_service_account.cert_manager.email])
}

resource "google_project_iam_member" "external_dns" {
  project = "homelab-ng"
  role    = "roles/dns.admin"
  member  = join(":", ["serviceAccount", google_service_account.external_dns.email])
}

resource "google_project_iam_member" "ddnsbot" {
  project = "homelab-ng"
  role    = "roles/dns.admin"
  member  = join(":", ["serviceAccount", google_service_account.ddns.email])
}

resource "google_service_account" "ddns" {
  account_id = "ddns-function"
}

resource "google_service_account" "external_dns" {
  account_id = "external-dns"
}

resource "google_service_account" "vault" {
  account_id = "vault-nuc"
}

resource "google_service_account" "cert_manager" {
  account_id = "cert-manager"
}

