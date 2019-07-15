# gke cluster with two node pools
data "google_container_engine_versions" "cloudlab" {}

module "corp" {
  source             = "../../../terraform/modules/gke-cluster"
  name               = "corp"
  kubernetes_version = data.google_container_engine_versions.cloudlab.latest_master_version
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  network_config = {
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

module "small" {
  source = "../../../terraform/modules/gke-nodepool"

  name               = "small"
  cluster            = module.corp.name
  node_count         = 3
  image_type         = "COS"
  kubernetes_version = data.google_container_engine_versions.cloudlab.latest_master_version
  service_account    = module.corp.node_service_account
  machine_type       = "g1-small"
  disk_size_gb       = 24
  preemptible        = true
  node_metadata      = "GKE_METADATA_SERVER"

  labels = {
    environment = "production"
    os          = "cos"
    runtime     = "containerd"
  }
}
