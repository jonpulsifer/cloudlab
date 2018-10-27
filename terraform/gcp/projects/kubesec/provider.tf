locals {
  billing_account = "009BE0-2F835F-F20651"
  folder          = "folders/55741234626"
  project         = "kubesec"
}

provider "google" {
  project = "kubesec"
  region  = "us-east4"
  zone    = "us-east4-b"
  version = "~> 1.18"
}

terraform {
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "state/lab"
    project        = "kubesec"
    encryption_key = ""
  }
}

resource "google_project" "kubesec" {
  name       = "cloudlab"
  project_id = "${local.project}"

  /* optional settings you may need */
  # org_id          = "${local.organization}"

  folder_id           = "${local.folder}"
  billing_account     = "${local.billing_account}"
  auto_create_network = false
  skip_delete         = true
}
