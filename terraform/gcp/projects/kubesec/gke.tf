# gke cluster with two node pools
module "gke" {
  source = "../../../modules/gke-beta-cluster"
  name   = "cloudlab"

  cluster_config = {
    online               = true
    network_policy       = true
    istio                = true
    binary_authorization = true
    kubernetes_version   = "1.11.7-gke.6"
    node_cidr            = "10.13.37.0/24"
    service_cidr         = "10.20.30.0/24"
    pod_cidr             = "10.100.0.0/19"
  }
}

module "cos" {
  source = "../../../modules/gke-beta-nodepool"

  nodepool_config = {
    online             = true
    name               = "cos"
    cluster            = "${module.gke.name}"
    node_count         = 1
    image_type         = "COS"
    service_account    = "${module.gke.node_service_account}"
    kubernetes_version = "1.11.7-gke.6"
    machine_type       = "n1-standard-1"
    preemptible        = false
    disk_size_gb       = 32
    metadata_proxy     = false
  }
}

module "small" {
  source = "../../../modules/gke-beta-nodepool"

  nodepool_config = {
    online             = true
    name               = "small"
    cluster            = "${module.gke.name}"
    node_count         = 2
    image_type         = "COS"
    kubernetes_version = "1.11.7-gke.6"
    service_account    = "${module.gke.node_service_account}"
    machine_type       = "g1-small"
    disk_size_gb       = 32
    preemptible        = true
    metadata_proxy     = false
  }
}
