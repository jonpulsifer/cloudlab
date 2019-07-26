locals {
  project = "kubesec"
  canada  = "northamerica-northeast1"
  usa     = "us-east4"
}

data "google_client_config" "current" {}
data "google_project" "kubesec" {
  project_id = "kubesec"
}

provider "google" {
  project = local.project
  region  = local.usa
  zone    = join("-", [local.usa, "b"])
  version = "~> 2.11"
}

provider "google-beta" {
  credentials = file("credentials.json")
  project     = local.project
  region      = local.usa
  zone        = join("-", [local.usa, "b"])
  version     = "~> 2.11"
}

provider "google" {
  alias   = "canada"
  project = local.project
  region  = local.canada
  zone    = join("-", [local.canada, "a"])
  version = "~> 2.11"
}

provider "google-beta" {
  alias   = "canada"
  project = local.project
  region  = local.canada
  zone    = join("-", [local.canada, "a"])
  version = "~> 2.11"
}

terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "state/lab"
    encryption_key = ""
  }
}
