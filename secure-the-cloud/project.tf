locals {
  # gcp config
  billing_account = "009BE0-2F835F-F20651"
  folder          = "folders/55741234626"

  # organization    = ""
  project = "secure-the-cloud"

  # default region/zone
  region = "us-east4"
  zone   = "us-east4-b"

  # gce network
  vm_cidr = "10.13.37.0/28"
}

provider "google" {
  project = "${local.project}"
  region  = "${local.region}"
  zone    = "${local.zone}"
  version = "~> 1.15"
}

terraform {
  backend "gcs" {
    bucket         = ""
    prefix         = "secure-the-cloud"
    project        = ""
    encryption_key = ""
  }
}

module "project" {
  source          = "../terraform/modules/gcp-project"
  name            = "lab "
  billing_account = "${local.billing_account}"
  project_id      = "${local.project}"
  folder_id       = "${local.folder}"

  /* one of folder_id or organization_id must be set
  org_id          = "${local.organization}" */
}

module "network" {
  source  = "../terraform/modules/gcp-vpc"
  name    = "lab"
  vm_cidr = "${local.vm_cidr}"
}

module "vm" {
  source = "../terraform/modules/gce-vm"
  name   = "bullseye"

  image_config = {
    family  = "ubuntu-1804-lts"
    project = "trusted-builds"
  }

  instance_config = {
    online       = false
    machine_type = "n1-standard-1"
    subnet       = "${module.network.subnet}"
    ssd_size     = 10
    preemptible  = false
  }
}
