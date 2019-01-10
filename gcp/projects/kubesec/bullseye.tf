locals {
  /* GCE settings */
  # turn the VMs on or off
  online = true

  # lab_cidr = "10.13.37.0/29"
}

# module "network" {
#   source = "../../../terraform/modules/gcp-vpc"
#   name   = "lab"

#   vm_cidr = "${local.lab_cidr}"
# }

# module "cos-vm" {
#   source = "../../../terraform/modules/gce-cos-vm"
#   name   = "cloudlab-cos"

#   image_config = {
#     family  = "cos-beta"
#     project = "cos-cloud"
#   }

#   instance_config = {
#     online       = "${local.online}"
#     cloud_init   = "${file("../../../cloud-init/cloudlab")}"
#     machine_type = "n1-standard-1"
#     ssd_size     = "10"
#     subnet       = "${module.network.subnet}"
#     preemptible  = false
#   }
# }

module "gke" {
  source = "../../../terraform/modules/gke-beta-cluster"
  name   = "cloudlab"

  cluster_config = {
    online               = true
    node_count           = 1
    image_type           = "COS"
    machine_type         = "n1-standard-1"
    disk_size_gb         = 20
    preemptible          = false
    metadata_proxy       = false
    network_policy       = true
    istio                = true
    binary_authorization = true
    node_cidr            = "10.13.37.0/24"
    service_cidr         = "10.20.30.0/24"
    pod_cidr             = "10.100.0.0/19"
  }
}

module "nodepool" {
  source = "../../../terraform/modules/gke-beta-nodepool"

  nodepool_config = {
    online             = true
    name               = "small"
    cluster            = "cloudlab"
    node_count         = 2
    image_type         = "COS_CONTAINERD"
    kubernetes_version = "1.11.6-gke.0"
    service_account    = "${module.gke.node_service_account}"
    machine_type       = "g1-small"
    disk_size_gb       = 10
    preemptible        = true
    metadata_proxy     = false
  }
}
