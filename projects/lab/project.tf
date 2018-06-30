locals {
  billing_account = "009BE0-2F835F-F20651"
  folder          = "folders/55741234626"
  project         = "kubesec"
}

provider "google" {
  credentials = "${file("credentials.json")}"
  project     = "kubesec"
  region      = "us-east4"
  zone        = "us-east4-b"
  version     = "~> 1.15"
}

terraform {
  backend "gcs" {
    bucket         = "kubesec"
    prefix         = "state/lab"
    project        = "kubesec"
  }
}

module "project" {
  source     = "../../terraform/modules/gcp-project"
  name       = "cloudlab"
  project_id = "${local.project}"

  /* optional settings you may need */
  # org_id          = "${local.organization}"

  folder_id       = "${local.folder}"
  billing_account = "${local.billing_account}"
}
