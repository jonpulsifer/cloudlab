resource "google_kms_key_ring" "vault" {
  name     = "vault"
  location = "${data.google_client_config.current.region}"
}

resource "google_kms_crypto_key" "vault" {
  name     = "vault"
  key_ring = "${google_kms_key_ring.vault.self_link}"

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
