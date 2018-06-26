provider "google" {
  project = "${var.gcp_config["project_id"]}"
  region  = "${var.gcp_config["region"]}"
  zone    = "${var.gcp_config["zone"]}"
  version = "~> 1.15"
}

resource "google_project" "secure-the-cloud" {
  name                = "lab "
  billing_account     = "${var.gcp_config["billing_account"]}"
  folder_id           = "${var.gcp_config["folder"]}"
  project_id          = "${var.gcp_config["project_id"]}"
  skip_delete         = true
  auto_create_network = "${var.gcp_config["auto_create_network"]}"
}

module "iam" {
  source     = "iam"
  gcp_config = "${var.gcp_config}"
}

module "network" {
  source     = "network"
  gcp_config = "${var.gcp_config}"
}

module "compute" {
  source     = "compute"
  gcp_config = "${var.gcp_config}"
}
