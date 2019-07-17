locals {
  name = "vault"
}

module "vault-vpc" {
  source  = "../../../terraform/modules/gce-vpc"
  name    = local.name
  vm_cidr = "10.2.0.0/28"
}

module "vault-igm" {
  source      = "../../../terraform/modules/gce-igm-shielded"
  name        = local.name
  subnet      = module.vault-vpc.subnet
  cloud_init  = templatefile("../../../cloud-init/single-service.tpl", { name = local.name })
  target_size = 1
  enable_lb   = false
  protocol    = "TCP"
  port_range  = "8200"
}

resource "google_project_iam_member" "vault" {
  role   = "roles/iam.serviceAccountTokenCreator"
  member = "serviceAccount:${module.vault-igm.service_account}"
}

resource "google_storage_bucket_object" "vault-config" {
  bucket = google_storage_bucket.cloud-lab.name
  name   = "services/vault/config.hcl"
  content = templatefile("../../../services/vault/config.hcl.tpl", {
    project        = data.google_client_config.current.project
    region         = data.google_client_config.current.region
    bucket         = google_storage_bucket.cloud-lab.name
    kms_key_ring   = local.name
    kms_crypto_key = local.name
  })
}

resource "google_compute_firewall" "ssh-to-vms" {
  name    = "ssh-to-vms"
  network = module.vault-vpc.network
  target_service_accounts = [
    module.vault-igm.service_account
  ]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "gke-to-vault" {
  name    = "gke-to-vault-api"
  network = module.vault-vpc.network
  target_service_accounts = [
    module.vault-igm.service_account
  ]

  allow {
    protocol = "tcp"
    ports    = ["8200"]
  }
  source_service_accounts = [
    module.corp.node_service_account
  ]
  source_ranges = [
    "10.0.0.0/24",   # nodes
    "10.100.0.0/19", # services
  ]
}

resource "google_compute_network_peering" "gke-to-vault" {
  name         = "gke-to-vault"
  network      = module.corp.network["self_link"]
  peer_network = module.vault-vpc.self_links["network"]
}

resource "google_compute_network_peering" "vault-to-gke" {
  name         = "vault-to-gke"
  network      = module.vault-vpc.self_links["network"]
  peer_network = module.corp.network["self_link"]
}
