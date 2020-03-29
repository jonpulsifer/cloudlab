provider "vault" {
  version = "~> 1.8"
  address = "https://vault.pulsifer.dev"
}

terraform {
  backend "gcs" {
    bucket = "kubesec"
    prefix = "state/vault"
  }
}
