resource "google_container_node_pool" "lab" {
  # https://github.com/hashicorp/terraform/issues/18682
  # provider = "${var.beta ? "google-beta" : "google" }"
  provider = "google-beta"

  name       = var.name
  cluster    = var.cluster
  node_count = var.node_count

  management {
    auto_upgrade = true
    auto_repair  = true
  }

  max_pods_per_node = 32

  node_config {
    image_type   = var.image_type
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    preemptible  = var.preemptible

    labels = var.labels

    workload_metadata_config {
      node_metadata = var.node_metadata
    }

    shielded_instance_config {
      enable_secure_boot          = var.shielded
      enable_integrity_monitoring = var.shielded
    }

    /* node identity */
    service_account = var.service_account

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  timeouts {
    create = "30m"
    delete = "30m"
  }
}
