provider "vault" {
  address = "https://vault.home.pulsifer.ca"
}

terraform {
  backend "gcs" {
    bucket = "homelab-ng"
    prefix = "terraform/vault"
  }
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.18"
    }
  }
  required_version = "~> 0.14"
}
