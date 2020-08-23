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
  version = "~> 3.14"
}

terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "registry.terraform.io/-/google"
      version = "~> 3.14"
    }
  }
  backend "gcs" {
    bucket = "kubesec"
    prefix = "state/homelab-ng"
  }
}
