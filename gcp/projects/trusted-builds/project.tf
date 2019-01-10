locals {
  # gcp config
  billing_account = "009BE0-2F835F-F20651"
  folder          = "folders/55741234626"

  # organization    = ""
  project = "trusted-builds"

  # default region/zone
  region = "northamerica-northeast1"
  zone   = "northamerica-northeast1-a"

  # gce network
  vm_cidr = "172.16.1.0/29"
}

provider "google" {
  project = "trusted-builds"
  region  = "northamerica-northeast1"
  zone    = "northamerica-northeast1-a"
  version = "~> 1.19"
}

terraform {
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "trusted-builds"
    project        = "kubesec"
    encryption_key = ""
  }
}

module "project" {
  source          = "../../../terraform/modules/gcp-project"
  name            = "trusted builder"
  billing_account = "${local.billing_account}"
  project_id      = "${local.project}"
  folder_id       = "${local.folder}"

  /* one of folder_id or organization_id must be set
  org_id          = "${local.organization}" */
}

module "network" {
  source  = "../../../terraform/modules/gcp-vpc"
  name    = "builds"
  vm_cidr = "${local.vm_cidr}"
}
