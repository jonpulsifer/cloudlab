resource "vault_approle_auth_backend_role" "cert_manager" {
  backend        = vault_auth_backend.approle.path
  role_name      = "cert-manager"
  token_policies = ["admin"]
}

resource "vault_approle_auth_backend_role" "home" {
  backend               = vault_auth_backend.approle.path
  role_name             = "home"
  secret_id_bound_cidrs = ["10.0.0.0/24"]
  token_policies        = ["home", "default"]
}

resource "vault_jwt_auth_backend_role" "google_default" {
  backend        = vault_jwt_auth_backend.google.path
  role_type      = "oidc"
  role_name      = "google-default"
  token_policies = ["default"]
  allowed_redirect_uris = [
    "http://localhost:8250/oidc/callback",
    "https://vault.home.pulsifer.ca/ui/vault/auth/google/oidc/callback",
    "https://vault.pulsifer.ca/ui/vault/auth/google/oidc/callback"
  ]
  user_claim   = "sub"
  groups_claim = "groups"
}
