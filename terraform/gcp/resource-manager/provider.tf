provider "google" {
  project = "kubesec"
  region  = "northamerica-northeast1"
  zone    = "northamerica-northeast1-a"
  version = "~> 2.0"
}

terraform {
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "state/resource-manager"
    encryption_key = ""
  }

  version = "~> 0.11.11"
}
