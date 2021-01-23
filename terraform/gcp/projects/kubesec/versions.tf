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
    bucket = "homelab-ng"
    prefix = "terraform/lab"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.50"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.35"
    }
  }
  required_version = ">= 0.14"
}
