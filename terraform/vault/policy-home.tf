resource "vault_policy" "home" {
  name = "home"

  policy = <<EOT
path "home/*" {
  capabilities = ["read", "list"]
}
path "home" {
  capabilities = ["read", "list"]
}
path "auth/token/create" {
  capabilities = ["create", "update"]
}
EOT
}
