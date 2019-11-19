locals {
  project = "wishlist-4362e"
  canada  = "northamerica-northeast1"
}

data "google_client_config" "current" {}
data "google_project" "wishlist" {
  project_id = local.project
}

provider "google" {
  project = local.project
  region  = local.canada
  zone    = join("-", [local.canada, "a"])
  version = "~> 2.20.1"
}

provider "google-beta" {
  project = local.project
  region  = local.canada
  zone    = join("-", [local.canada, "a"])
  version = "~> 2.20.1"
}

terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "state/wishlist"
    encryption_key = ""
  }
}
