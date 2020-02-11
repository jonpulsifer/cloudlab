resource "google_dns_managed_zone" "pulsifer-dev" {
  name        = "pulsifer-dev"
  dns_name    = "pulsifer.dev."
  description = "TLS development environment"

  labels = {
    domain      = "pulsifer-dev"
    environment = "development"
  }

  dnssec_config {
    kind          = "dns#managedZoneDnsSecConfig"
    non_existence = "nsec3"
    state         = "off"

    default_key_specs {
      algorithm  = "rsasha256"
      key_length = 2048
      key_type   = "keySigning"
      kind       = "dns#dnsKeySpec"
    }
    default_key_specs {
      algorithm  = "rsasha256"
      key_length = 1024
      key_type   = "zoneSigning"
      kind       = "dns#dnsKeySpec"
    }
  }
}

resource "google_dns_managed_zone" "k8s-pulsifer-dev" {
  name        = "k8s-pulsifer-dev"
  dns_name    = "k8s.pulsifer.dev."
  description = "TLS development environment"

  labels = {
    domain      = "k8s-pulsifer-dev"
    environment = "development"
  }
}
