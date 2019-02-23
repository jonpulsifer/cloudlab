locals {
  project = "kubesec"
  region  = "northamerica-northeast1"
  zone    = "northamerica-northeast1-a"
}

provider "google" {
  project = "${local.project}"
  region  = "$${local.region}"
  zone    = "${local.zone}"
  version = "~> 2.0"
}

terraform {
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "state/resource-manager"
    project        = "kubesec"
    encryption_key = ""
  }

  version = "~> 0.11.11"
}
