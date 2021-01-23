terraform {
  backend "gcs" {
    bucket = "homelab-ng"
    prefix = "terraform/unifi"
  }
  required_providers {
    unifi = {
      source = "paultyng/unifi"
      version = "~> 0.19"
    }
  }
}

provider "unifi" {
  username = "terraform"
  # password = "" or UNIFI_PASSWORD env
  api_url  = "https://udm.home.pulsifer.ca"
  allow_insecure = true
  # site = "default"
}
