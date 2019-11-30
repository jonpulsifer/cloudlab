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
  version = "~> 3.0.0-beta.1"
}

terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "state/jonpulsifer"
    encryption_key = ""
  }
}
