locals {
  project = "kubesec"
  region  = "northamerica-northeast1"
  zone    = join("-", [local.region, "a"])
}

provider "google" {
  project = local.project
  region  = local.region
  zone    = local.zone
  version = "~> 3.14"
}

provider "google-beta" {
  #  credentials = file("credentials.json")
  project = local.project
  region  = local.region
  zone    = local.zone
  version = "~> 3.14"
}

terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket = "kubesec"
    prefix = "state/resource-manager"
  }
}
