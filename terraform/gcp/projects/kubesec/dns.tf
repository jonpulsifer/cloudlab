resource "google_dns_managed_zone" "lolwtf" {
  name        = "k8s-lolwtf-ca"
  dns_name    = "k8s.lolwtf.ca."
  description = "domain that hosts my k8s things"

  labels = {
    domain      = "k8s-lolwtf-ca"
    environment = "production"
  }
}

data "google_compute_address" "ingress" {
  name = "gke-november"
}

resource "google_dns_record_set" "k8s-lolwtf-ca" {
  name         = "${google_dns_managed_zone.lolwtf.dns_name}"
  managed_zone = "${google_dns_managed_zone.lolwtf.name}"
  type         = "A"
  ttl          = 300

  rrdatas = ["${data.google_compute_address.ingress.address}"]
}

resource "google_dns_record_set" "vault" {
  name         = "vault.${google_dns_managed_zone.lolwtf.dns_name}"
  managed_zone = "${google_dns_managed_zone.lolwtf.name}"
  type         = "CNAME"
  ttl          = 300

  rrdatas = ["${google_dns_managed_zone.lolwtf.dns_name}"]
}

resource "google_dns_record_set" "atlantis" {
  name         = "atlantis.${google_dns_managed_zone.lolwtf.dns_name}"
  managed_zone = "${google_dns_managed_zone.lolwtf.name}"
  type         = "CNAME"
  ttl          = 300

  rrdatas = ["${google_dns_managed_zone.lolwtf.dns_name}"]
}
