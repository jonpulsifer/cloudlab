locals {
  project = "kubesec"
  canada  = "northamerica-northeast1"
  usa     = "us-east4"
}

data "google_client_config" "current" {}
data "google_project" "current" {
  project_id = local.project
}

provider "google" {
  project = local.project
  region  = local.usa
  zone    = join("-", [local.usa, "b"])
  version = "~> 3.0.0-beta.1"
}

provider "google-beta" {
  project = local.project
  region  = local.usa
  zone    = join("-", [local.usa, "b"])
  version = "~> 3.0.0-beta.1"
}

provider "google" {
  alias   = "canada"
  project = local.project
  region  = local.canada
  zone    = join("-", [local.canada, "b"])
  version = "~> 3.0.0-beta.1"
}

provider "google-beta" {
  alias   = "canada"
  project = local.project
  region  = local.canada
  zone    = join("-", [local.canada, "b"])
  version = "~> 3.0.0-beta.1"
}

terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "state/lab"
    encryption_key = ""
  }
}
