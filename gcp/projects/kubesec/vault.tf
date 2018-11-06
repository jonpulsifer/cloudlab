resource "google_service_account" "vault" {
  account_id   = "vault-server"
  display_name = "service account for vault"
}
resource "google_storage_bucket_iam_member" "vault" {
  bucket = "cloud-lab"
  role   = "roles/storage.admin"

  member = "serviceAccount:${google_service_account.vault.email}"
}

resource "google_kms_key_ring" "vault" {
  name     = "vault"
  location = "us-east4"
}
resource "google_kms_crypto_key" "vault" {
  name            = "vault"
  key_ring        = "${google_kms_key_ring.vault.self_link}"

  // one week
  rotation_period = "604800s"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_key_ring_iam_member" "vault" {
  key_ring_id = "${google_kms_key_ring.vault.location}/${google_kms_key_ring.vault.name}"
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member      = "serviceAccount:${google_service_account.vault.email}"
}
