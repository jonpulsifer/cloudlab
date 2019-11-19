resource "google_dns_managed_zone" "wishlist-app" {
  name        = "wishlist-app"
  dns_name    = "wishin.app."
  description = "Domain for the wishlist app"

  labels = {
    domain      = "wishlist-app"
    environment = "production"
  }
}
