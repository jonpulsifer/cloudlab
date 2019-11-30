locals {
  project = "trusted-builds"
  region  = "northamerica-northeast1"
  zone    = join("-", [local.region, "a"])
}

data "google_client_config" "current" {}
data "google_project" "trusted-builds" {
  project_id = "trusted-builds"
}

provider "google" {
  project = local.project
  region  = local.region
  zone    = local.zone
  version = "~> 3.0.0-beta.1"
}

provider "google-beta" {
  #  credentials = file("credentials.json")
  project = local.project
  region  = local.region
  zone    = local.zone
  version = "~> 3.0.0-beta.1"
}

terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "trusted-builds"
    encryption_key = ""
  }
}
