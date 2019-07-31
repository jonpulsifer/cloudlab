resource "google_dns_managed_zone" "home-pulsifer-ca" {
  name        = "home-pulsifer-ca"
  dns_name    = "home.pulsifer.ca."
  description = "DNS for my LAN"

  labels = {
    domain      = "home-pulsifer-ca"
    environment = "home"
  }
}
