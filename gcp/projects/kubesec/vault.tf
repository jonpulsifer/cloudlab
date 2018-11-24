resource "google_service_account" "vault" {
  account_id   = "vault-server"
  display_name = "service account for vault"
}

resource "google_storage_bucket_iam_member" "vault" {
  bucket = "cloud-lab"
  role   = "roles/storage.admin"

  member = "serviceAccount:${google_service_account.vault.email}"
}

resource "google_kms_key_ring" "vault" {
  name     = "vault"
  location = "us-east4"
}

resource "google_kms_crypto_key" "vault" {
  name     = "vault"
  key_ring = "${google_kms_key_ring.vault.self_link}"

  // one week
  rotation_period = "604800s"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_key_ring_iam_member" "vault" {
  key_ring_id = "${google_kms_key_ring.vault.location}/${google_kms_key_ring.vault.name}"
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member      = "serviceAccount:${google_service_account.vault.email}"
}

provider "vault" {
  version = "~> 1.3"
  address = "https://vault.k8s.lolwtf.ca"
}

resource "vault_auth_backend" "userpass" {
  type = "userpass"
  path = "userpass"
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = "kubernetes"
}

resource "vault_policy" "admin" {
  name = "admin"

  policy = <<EOF
# Manage auth methods broadly across Vault
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete auth methods
path "sys/auth/*"
{
  capabilities = ["create", "update", "delete", "sudo"]
}

# List auth methods
path "sys/auth"
{
  capabilities = ["read"]
}

# List existing policies
path "sys/policy"
{
  capabilities = ["read"]
}

# Create and manage ACL policies via CLI
path "sys/policy/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create and manage ACL policies via API & UI
path "sys/policies/acl/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List, create, update, and delete key/value secrets
path "secret/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage secret engines
path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List existing secret engines.
path "sys/mounts"
{
  capabilities = ["read"]
}

# Read health checks
path "sys/health"
{
  capabilities = ["read", "sudo"]
}
EOF
}
