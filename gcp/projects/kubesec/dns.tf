resource "google_dns_managed_zone" "k8s-pulsifer-dev" {
  name        = "k8s-pulsifer-dev"
  dns_name    = "k8s.pulsifer.dev."
  description = "TLS development environment"

  labels = {
    domain      = "k8s-pulsifer-dev"
    environment = "development"
  }
}
