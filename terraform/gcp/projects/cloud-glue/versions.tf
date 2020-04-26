locals {
  project = "cloud-glue"
  region  = "northamerica-northeast1"
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
  backend "local" {}
}
