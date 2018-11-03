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
    machine_type         = "n1-standard-1"
    disk_size_gb         = 20
    preemptible          = false
    metadata_proxy       = false
    network_policy       = false
    binary_authorization = true
    node_cidr            = "10.13.37.0/24"
    service_cidr         = "10.20.30.0/24"
    pod_cidr             = "10.100.0.0/19"
  }
}
