locals {
  project = "wishlist-4362e"
  region  = "northamerica-northeast1"
}

data "google_project" "wishlist" {
  project_id = local.project
}

provider "google" {
  project = local.project
  region  = local.region
  zone    = join("-", [local.region, "b"])
  version = "~> 3.14"
}

provider "google-beta" {
  project = local.project
  region  = local.region
  zone    = join("-", [local.region, "b"])
  version = "~> 3.14"
}

terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket = "kubesec"
    prefix = "state/wishlist"
  }
}
