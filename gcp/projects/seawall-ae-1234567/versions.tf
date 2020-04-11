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
