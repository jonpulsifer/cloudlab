data "google_client_config" "current" {}

data "google_project" "kubesec" {
  project_id = "kubesec"
}

provider "google" {
  project = "kubesec"
  region  = "us-east4"
  zone    = "us-east4-b"
  version = "~> 2.0"
}

provider "google-beta" {
  project = "kubesec"
  region  = "us-east4"
  zone    = "us-east4-b"
  version = "~> 2.0"
}

provider "kubernetes" {
  version = "~> 1.5"
}

terraform {
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "state/lab"
    project        = "kubesec"
    encryption_key = ""
  }

  version = "~> 0.11.11"
}
