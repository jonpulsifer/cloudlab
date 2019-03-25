resource "vault_pki_secret_backend" "pki" {
  path                      = "pki"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

resource "vault_pki_secret_backend_role" "pulsifer-dev" {
  backend = "${vault_pki_secret_backend.pki.path}"
  name    = "pulsifer-dev"

  allow_subdomains = true
  allowed_domains  = ["pulsifer.dev"]

  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment",
  ]

  max_ttl = 259200
}

resource "vault_pki_secret_backend_intermediate_cert_request" "k8s-pulsifer-dev" {
  depends_on = ["vault_pki_secret_backend.pki"]

  backend = "${vault_pki_secret_backend.pki.path}"

  type               = "exported"
  common_name        = "k8s.pulsifer.dev"
  key_type           = "rsa"
  key_bits           = "4096"
  private_key_format = "der"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "k8s-pulsifer-dev" {
  depends_on = ["vault_pki_secret_backend_intermediate_cert_request.k8s-pulsifer-dev"]

  backend = "${vault_pki_secret_backend.pki.path}"

  csr         = "${vault_pki_secret_backend_intermediate_cert_request.k8s-pulsifer-dev.csr}"
  common_name = "Cluster Services Intermediate Certificate Authority"

  exclude_cn_from_sans = true
  ou                   = "Kubernetes"
  organization         = "Pulsifer Technologies"
  use_csr_values       = true
}

resource "vault_pki_secret_backend" "k8s-pki" {
  path                      = "k8s-pki"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}
