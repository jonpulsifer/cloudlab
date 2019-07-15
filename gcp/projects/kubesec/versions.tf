locals {
  project = "kubesec"
  region  = "us-east4"
  zone    = join("-", [local.region, "b"])
}

data "google_client_config" "current" {}
data "google_project" "kubesec" {
  project_id = "kubesec"
}

provider "google" {
  project = local.project
  region  = local.region
  zone    = local.zone
  version = "~> 2.10"
}

provider "google-beta" {
  credentials = file("credentials.json")
  project     = local.project
  region      = local.region
  zone        = local.zone
  version     = "~> 2.10"
}

terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "state/lab"
    encryption_key = ""
  }
}
