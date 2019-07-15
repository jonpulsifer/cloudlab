resource "google_kms_key_ring" "igm" {
  name     = var.name
  location = data.google_client_config.current.region
}

resource "google_kms_crypto_key" "igm" {
  name     = var.name
  key_ring = google_kms_key_ring.igm.self_link

  // 30 days
  rotation_period = "2592000s"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_key_ring_iam_binding" "igm" {
  key_ring_id = google_kms_key_ring.igm.id
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = [
    "serviceAccount:${google_service_account.igm.email}",
    "serviceAccount:service-${data.google_project.current.number}@compute-system.iam.gserviceaccount.com",
  ]
}
