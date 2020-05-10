resource "google_kms_key_ring" "vault" {
  name     = "vault"
  location = "northamerica-northeast1"
}

resource "google_kms_crypto_key" "vault" {
  name     = "vault"
  key_ring = google_kms_key_ring.vault.self_link

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key_iam_member" "vault" {
  crypto_key_id = google_kms_crypto_key.vault.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = format("serviceAccount:%s", google_service_account.vault.email)
}
