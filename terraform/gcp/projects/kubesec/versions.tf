locals {
  project = "kubesec"
  region  = "us-east4"
  zone    = join("-", [local.region, "b"])
}

provider "google" {
  project = local.project
  region  = local.region
  zone    = local.zone
}

provider "google-beta" {
  project = local.project
  region  = local.region
  zone    = local.zone
}

terraform {
  backend "gcs" {
    bucket = "kubesec"
    prefix = "state/lab"
  }

  required_providers {
    google = {
      source  = "registry.terraform.io/-/google"
      version = "~> 3.35"
    }
    google-beta = {
      source  = "registry.terraform.io/-/google-beta"
      version = "~> 3.35"
    } 
  }
}
