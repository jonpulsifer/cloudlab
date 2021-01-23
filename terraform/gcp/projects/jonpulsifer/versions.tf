locals {
  project = "jonpulsifer"
  region  = "northamerica-northeast1"
  zone    = join("-", [local.region, "a"])
}

data "google_client_config" "current" {}

provider "google" {
  project = local.project
  region  = local.region
  zone    = local.zone
}

terraform {
  backend "gcs" {
    bucket = "homelab-ng"
    prefix = "terraform/jonpulsifer"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.53"
    }
  }
  required_version = ">= 0.14"
}
