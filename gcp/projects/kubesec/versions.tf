locals {
  project = "kubesec"
  region  = "us-east4"
  zone    = join("-", [local.region, "b"])
}

provider "google" {
  project = local.project
  region  = local.region
  zone    = join("-", [local.region, "b"])
}

provider "google-beta" {
  project = local.project
  region  = local.region
}

terraform {
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "state/lab"
    encryption_key = ""
  }
}
