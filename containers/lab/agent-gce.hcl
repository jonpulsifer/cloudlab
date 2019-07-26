exit_after_auth = truepid_file = "/home/vault/pidfile"
auto_auth {
    method "gcp" {
        mount_path = "auth/gcp"
        config = {
            role = "example",
            type = "gce"
        }
    }
    sink "file" {
        config = {
            path = "/home/vault/.vault-token"
        }
    }
}
