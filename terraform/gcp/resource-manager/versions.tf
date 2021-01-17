locals {
  project = "kubesec"
  region  = "northamerica-northeast1"
  zone    = join("-", [local.region, "a"])
}

provider "google" {
  project = local.project
  region  = local.region
  zone    = local.zone
}

provider "google-beta" {
  project = local.project
  region  = local.region
  zone    = local.zone
}

terraform {
  required_version = ">= 0.13"
  backend "gcs" {
    bucket = "kubesec"
    prefix = "state/resource-manager"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.35"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.35"
    }
  }
}
