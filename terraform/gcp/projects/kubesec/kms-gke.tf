resource "google_kms_key_ring" "gke" {
  name     = "gke"
  location = "${data.google_client_config.current.region}"
}

resource "google_kms_crypto_key" "gke" {
  name     = "gke"
  key_ring = "${google_kms_key_ring.gke.self_link}"

  // four weeks
  rotation_period = "2419200s"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_key_ring_iam_member" "gke" {
  key_ring_id = "${google_kms_key_ring.gke.location}/${google_kms_key_ring.gke.name}"
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member      = "serviceAccount:service-${data.google_project.kubesec.number}@container-engine-robot.iam.gserviceaccount.com"
}
