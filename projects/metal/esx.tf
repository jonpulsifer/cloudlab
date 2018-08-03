locals {
  esxi_host = ""
}

provider "vsphere" {
  user                 = ""
  password             = ""
  vsphere_server       = ""
  allow_unverified_ssl = true
  version = "~> 1.6"
}

terraform {
  backend "gcs" {
    bucket         = ""
    prefix         = ""
    project        = ""
    encryption_key = ""
  }
}
data "vsphere_datacenter" "lab" {
  name = "Home"
}
data "vsphere_host" "host" {
  name          = "${local.esxi_host}"
  datacenter_id = "${data.vsphere_datacenter.lab.id}"
}

data "vsphere_datastore" "ssd" {
  name          = "ssd-intel-500gb"
  datacenter_id = "${data.vsphere_datacenter.lab.id}"
}

data "vsphere_resource_pool" "host" {
  name          = "${local.esxi_host}/Resources"
  datacenter_id = "${data.vsphere_datacenter.lab.id}"
}

data "vsphere_network" "vms" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.lab.id}"
}
resource "vsphere_folder" "builds" {
  path          = "builds"
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.lab.id}"
}

