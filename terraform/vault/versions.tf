provider "vault" {
  address = "https://vault.home.pulsifer.ca"
}

terraform {
  backend "gcs" {
    bucket = "kubesec"
    prefix = "state/vault"
  }
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "2.16.0"
    }
  }
}
