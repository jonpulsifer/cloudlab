# gke cluster with two node pools
data "google_container_engine_versions" "cloudlab" {}

module "corp" {
  source             = "../../../terraform/modules/gke-cluster"
  name               = "corp"
  kubernetes_version = data.google_container_engine_versions.cloudlab.latest_master_version
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  network_config = {
    enable_natgw   = true
    private_nodes  = true
    private_master = false
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
  network = module.corp.network["self_link"]
  target_service_accounts = [
    module.corp.node_service_account
  ]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

module "small" {
  source = "../../../terraform/modules/gke-nodepool"

  name               = "std"
  cluster            = module.corp.name
  node_count         = 2
  image_type         = "COS"
  kubernetes_version = data.google_container_engine_versions.cloudlab.latest_master_version
  service_account    = module.corp.node_service_account
  machine_type       = "custom-2-2048"
  disk_size_gb       = 24
  preemptible        = true
  node_metadata      = "GKE_METADATA_SERVER"

  labels = {
    environment = "production"
    os          = "cos"
    runtime     = "containerd"
  }
}
