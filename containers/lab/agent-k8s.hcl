exit_after_auth = true
pid_file = "/home/vault/pidfile"

auto_auth {
    method "kubernetes" {
        mount_path = "auth/kubernetes"
        config = {
            role = "cloudlab"
        }
    }

    sink "file" {
        config = {
            path = "/home/vault/.vault-token"
        }
    }
}
