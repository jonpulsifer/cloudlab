locals {
  /* GCE settings */
  # turn the VMs on or off
  online = true

  # lab_cidr = "10.13.37.0/29"
}

module "gke" {
  source = "../../../terraform/modules/gke-beta-cluster"
  name   = "cloudlab"

  cluster_config = {
    online               = true
    network_policy       = true
    istio                = true
    binary_authorization = true
    node_cidr            = "10.13.37.0/24"
    service_cidr         = "10.20.30.0/24"
    pod_cidr             = "10.100.0.0/19"
  }
}

module "nodepool-containerd" {
  source = "../../../terraform/modules/gke-beta-nodepool"

  nodepool_config = {
    online             = true
    name               = "small"
    cluster            = "cloudlab"
    node_count         = 1
    image_type         = "COS_CONTAINERD"
    kubernetes_version = "1.11.6-gke.0"
    service_account    = "${module.gke.node_service_account}"
    machine_type       = "g1-small"
    disk_size_gb       = 10
    preemptible        = true
    metadata_proxy     = false
  }
}

module "nodepool-shielded" {
  source = "../../../terraform/modules/gke-beta-nodepool"

  nodepool_config = {
    online             = true
    name               = "shielded"
    cluster            = "cloudlab"
    node_count         = 1
    image_type         = "COS_SHIELDED"
    kubernetes_version = "1.11.6-gke.0"
    service_account    = "${module.gke.node_service_account}"
    machine_type       = "g1-small"
    disk_size_gb       = 10
    preemptible        = true
    metadata_proxy     = false
  }
}
