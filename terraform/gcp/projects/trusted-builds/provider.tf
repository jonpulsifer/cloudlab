data "google_client_config" "current" {}

data "google_project" "trusted-builds" {
  project_id = "trusted-builds"
}

provider "google" {
  project = "trusted-builds"
  region  = "northamerica-northeast1"
  zone    = "northamerica-northeast1-a"
  version = "~> 2.0"
}

terraform {
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "trusted-builds"
    project        = "kubesec"
    encryption_key = ""
  }
}
