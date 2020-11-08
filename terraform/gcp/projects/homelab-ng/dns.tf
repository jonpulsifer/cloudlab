resource "google_dns_managed_zone" "home-pulsifer-ca" {
  name        = "home-pulsifer-ca"
  dns_name    = "home.pulsifer.ca."
  description = "DNS for my LAN"

  labels = {
    domain      = "home-pulsifer-ca"
    environment = "home"
  }
}
resource "google_dns_managed_zone" "wishlist-app" {
  name        = "wishlist-app"
  dns_name    = "wishin.app."
  description = "Domain for the wishlist app"

  labels = {
    domain      = "wishlist-app"
    environment = "production"
  }
}
