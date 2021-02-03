terraform {
  backend "gcs" {
    bucket = "homelab-ng"
    prefix = "terraform/unifi"
  }
  required_providers {
    unifi = {
      # overridden in ~/.terraformrc
      source  = "paultyng/unifi"
      version = "~> 0.19"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.18"
    }
  }
}

provider "vault" {
  address = "https://vault.home.pulsifer.ca"
  auth_login {
    path = "auth/approle/login"
    parameters = {
      "role_id"   = "c8dff126-5c2b-8443-4b16-96f12d0658ad"
      "secret_id" = "3781fce9-d9f8-1ce4-d6bf-dc51a7727f38"
    }
  }
}

provider "unifi" {
  username = "terraform"
  # password = "" or UNIFI_PASSWORD env
  api_url        = "https://udm.home.pulsifer.ca"
  allow_insecure = true
  # site = "default"
}
