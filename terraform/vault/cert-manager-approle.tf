resource "vault_approle_auth_backend_role" "cert-manager" {
  backend   = "${vault_auth_backend.approle.path}"
  role_name = "cert-manager"
  policies  = ["admin"]
}
