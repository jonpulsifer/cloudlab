resource "google_dns_managed_zone" "lolwtf" {
  name        = "lolwtf"
  dns_name    = "k8s.lolwtf.ca."
  description = "k8s.lolwtf.ca"
}
