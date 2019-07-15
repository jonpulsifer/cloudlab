resource "google_container_node_pool" "lab" {
  # https://github.com/hashicorp/terraform/issues/18682
  # provider = "${var.beta ? "google-beta" : "google" }"
  provider = "google-beta"

  name       = var.name
  cluster    = var.cluster
  node_count = var.node_count
  version    = var.kubernetes_version

  # depends_on = ["google_container_cluster.lab"]
  management {
    auto_upgrade = var.auto_upgrade
    auto_repair  = var.auto_repair
  }

  max_pods_per_node = 32

  node_config {
    /* "UBUNTU", "COS", "COS_CONTAINERD" */
    image_type   = var.image_type
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    preemptible  = var.preemptible

    labels = var.labels

    workload_metadata_config {
      node_metadata = var.node_metadata
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
