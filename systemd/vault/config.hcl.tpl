api_addr     = "https://0.0.0.0:8200"
cluster_addr = "https://0.0.0.0:8201"
ui = true

seal "gcpckms" {
    project     = "${project}"
    region      = "${region}"
    key_ring    = "${kms_key_ring}"
    crypto_key  = "${kms_crypto_key}"
}

storage "gcs" {
    bucket     = "${bucket}"
    ha_enabled = "false"
}

listener "tcp" {
    address       = "0.0.0.0:8200"
    tls_cert_file = "/etc/vault/tls/tls.crt"
    tls_key_file  = "/etc/vault/tls/tls.key"
    tls_disable_client_certs = true
}
