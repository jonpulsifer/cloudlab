locals {
  project = "kubesec"
  region  = "northamerica-northeast1"
  zone    = join("-", [local.region, "a"])
  metadata_projects = [
    "homelab-ng",
    "kubesec",
    "trusted-builds",
  ]
}

provider "google" {
  project = local.project
  region  = local.region
  zone    = local.zone
  version = "~> 3.17"
}

provider "google-beta" {
  project = local.project
  region  = local.region
  zone    = local.zone
  version = "~> 3.17"
}

terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket = "kubesec"
    prefix = "state/resource-manager"
  }
}
