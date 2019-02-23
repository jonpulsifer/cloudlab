resource "vault_auth_backend" "userpass" {
  type = "userpass"
  path = "userpass"
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = "kubernetes"
}
