resource "vault_auth_backend" "userpass" {
  type = "userpass"
  path = "userpass"
  tune {
    listing_visibility = "unauth"
  }
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = "kubernetes"
}

resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_jwt_auth_backend" "google" {
  path               = "google"
  type               = "oidc"
  oidc_discovery_url = "https://accounts.google.com"
  oidc_client_id     = "629296473058-g6i3mt60i4t3sckpiru52d92gat6tqk4.apps.googleusercontent.com"
  oidc_client_secret = ""
  default_role       = "google-default"
  tune {
    allowed_response_headers     = []
    audit_non_hmac_request_keys  = []
    audit_non_hmac_response_keys = []
    default_lease_ttl            = "768h"
    listing_visibility           = "unauth"
    max_lease_ttl                = "768h"
    passthrough_request_headers  = []
    token_type                   = "default-service"
  }
  provider_config = {
    "provider" : "gsuite",
    "gsuite_service_account" : "/var/run/secrets/gcp/credentials.json",
    "gsuite_admin_impersonate" : "vault@pulsifer.ca",
    #"fetch_groups": true,
    #"fetch_user_info": false,
    # "groups_recurse_max_depth": "5"
  }
  lifecycle {
    ignore_changes = [oidc_client_secret, provider_config]
  }
}
