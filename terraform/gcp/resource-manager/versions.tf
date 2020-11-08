locals {
  project = "kubesec"
  region  = "northamerica-northeast1"
  zone    = join("-", [local.region, "a"])
}

provider "google" {
  project = local.project
  region  = local.region
  zone    = local.zone
  version = "~> 3.46"
}

provider "google-beta" {
  project = local.project
  region  = local.region
  zone    = local.zone
  version = "~> 3.46"
}

terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket = "kubesec"
    prefix = "state/resource-manager"
  }
}
