# gke cluster with two node pools
module "gke" {
  source = "../../../modules/gke-beta-cluster"
  name   = "cloudlab"

  network_policy             = true
  istio                      = true
  binary_authorization       = true
  google_cloud_load_balancer = true
  kubernetes_version         = "1.11.7-gke.6"
  logging_service            = "logging.googleapis.com"

  network_config = {
    node_cidr    = "10.13.37.0/24"
    service_cidr = "10.20.30.0/24"
    pod_cidr     = "10.100.0.0/19"
  }

  labels = {
    environment = "production"
  }
}

module "cos" {
  source = "../../../modules/gke-beta-nodepool"

  online             = true
  name               = "containerd"
  cluster            = "${module.gke.name}"
  node_count         = 1
  image_type         = "COS_CONTAINERD"
  service_account    = "${module.gke.node_service_account}"
  kubernetes_version = "1.11.7-gke.6"
  machine_type       = "n1-standard-1"
  preemptible        = false
  disk_size_gb       = 32
  metadata_proxy     = false

  labels = {
    environment = "true"
    os          = "cos"
    runtime     = "containerd"
  }
}

module "buildah" {
  source = "../../../modules/gke-beta-nodepool"

  online             = true
  name               = "buildah"
  cluster            = "${module.gke.name}"
  node_count         = 1
  image_type         = "UBUNTU"
  kubernetes_version = "1.11.7-gke.6"
  service_account    = "${module.gke.node_service_account}"
  machine_type       = "g1-small"
  disk_size_gb       = 32
  preemptible        = true
  metadata_proxy     = false

  labels = {
    environment = "production"
    os          = "ubuntu"
    runtime     = "docker"
  }
}

module "small" {
  source = "../../../modules/gke-beta-nodepool"

  online             = true
  name               = "small"
  cluster            = "${module.gke.name}"
  node_count         = 1
  image_type         = "COS_CONTAINERD"
  kubernetes_version = "1.11.7-gke.6"
  service_account    = "${module.gke.node_service_account}"
  machine_type       = "g1-small"
  disk_size_gb       = 32
  preemptible        = true
  metadata_proxy     = false

  labels = {
    environment = "production"
    os          = "cos"
    runtime     = "containerd"
  }
}
