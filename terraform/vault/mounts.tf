resource "vault_mount" "home" {
  path        = "home"
  type        = "kv"
  description = "Home Secrets, generally accessible from inside the homelab network"
}
