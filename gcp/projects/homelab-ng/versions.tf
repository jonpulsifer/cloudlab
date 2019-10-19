locals {
  project = "homelab-ng"
  region  = "northamerica-northeast1"
  zone    = join("-", [local.region, "a"])
}

data "google_client_config" "current" {}

provider "google" {
  project = local.project
  region  = local.region
  zone    = local.zone
  version = "~> 2.17"
}

terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "state/homelab-ng"
    encryption_key = ""
  }
}
