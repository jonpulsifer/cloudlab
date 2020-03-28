locals {
  project = "trusted-builds"
  region  = "northamerica-northeast1"
  zone    = join("-", [local.region, "a"])
}

data "google_project" "trusted-builds" {
  project_id = "trusted-builds"
}

provider "google" {
  project = local.project
  region  = local.region
  zone    = local.zone
  version = "~> 3.7"
}

terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket = "kubesec"
    prefix = "trusted-builds"
  }
}
