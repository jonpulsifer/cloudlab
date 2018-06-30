locals {
  /* GCE settings */
  # turn the VM on or off
  online = true

  linux_user = "jawn"
  ssd_size   = 10
  vm_cidr    = "10.13.37.0/29"
}

module "network" {
  source = "../../terraform/modules/gcp-vpc"
  name   = "lab"

  vm_cidr = "${local.vm_cidr}"
}

module "vm" {
  source = "../../terraform/modules/gce-vm"
  name   = "bullseye"

  image_config = {
    family  = "ubuntu-1804-lts"
    project = "trusted-builds"
  }

  instance_config = {
    online       = "${local.online}"
    machine_type = "n1-standard-1"
    subnet       = "${module.network.subnet}"
    linux_user   = "${local.linux_user}"
    mount_point  = "/home/${local.linux_user}"
    ssd_size     = "${local.ssd_size}"
    preemptible  = false
  }
}
