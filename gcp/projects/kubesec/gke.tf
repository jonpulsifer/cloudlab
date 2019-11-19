# gke cluster with two node pools
data "google_container_engine_versions" "cloudlab" {}

module "gke" {
  source             = "../../../terraform/modules/gke-cluster"
  name               = "lab"
  kubernetes_version = data.google_container_engine_versions.cloudlab.latest_master_version

  monitoring_service         = "none"
  logging_service            = "none"
  google_cloud_load_balancer = true
  network_config = {
    enable_ssh     = true
    enable_natgw   = false
    private_master = false
    private_nodes  = false
    node_cidr      = "10.0.0.0/24"
    service_cidr   = "10.10.0.0/16"
    pod_cidr       = "10.100.0.0/19"
    master_cidr    = "192.168.0.0/28"
  }

  master_authorized_networks = {
    cidr_block   = "0.0.0.0/0"
    display_name = "internet"
  }

  labels = {
    environment = "production"
  }
}

resource "google_compute_firewall" "ssh-to-gke-nodes" {
  name    = "ssh-to-gke-nodes"
  network = module.gke.network["self_link"]
  target_service_accounts = [
    module.gke.node_service_account
  ]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

module "gke-prepaid" {
  source = "../../../terraform/modules/gke-nodepool"

  name               = "n1"
  cluster            = module.gke.name
  node_count         = 1
  image_type         = "UBUNTU"
  kubernetes_version = data.google_container_engine_versions.cloudlab.latest_master_version
  service_account    = module.gke.node_service_account
  machine_type       = "n1-standard-1"
  disk_size_gb       = 24
  preemptible        = false
  node_metadata      = "GKE_METADATA_SERVER"

  metadata = {
    disable-legacy-endpoints = "true"
    enable-guest-attributes  = "true"
    enable-os-inventory      = "true"
  }

  labels = {
    environment = "production"
    os          = "ubuntu"
    runtime     = "docker"
  }
}

module "gke-nodes" {
  source = "../../../terraform/modules/gke-nodepool"

  name               = "g1"
  cluster            = module.gke.name
  node_count         = 2
  image_type         = "COS"
  kubernetes_version = data.google_container_engine_versions.cloudlab.latest_master_version
  service_account    = module.gke.node_service_account
  machine_type       = "g1-small"
  disk_size_gb       = 24
  preemptible        = true
  node_metadata      = "GKE_METADATA_SERVER"

  labels = {
    environment = "production"
    os          = "ubuntu"
    runtime     = "docker"
  }
}
