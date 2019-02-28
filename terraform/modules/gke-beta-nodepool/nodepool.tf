resource "google_container_node_pool" "lab" {
  # https://github.com/hashicorp/terraform/issues/18682
  # provider = "${var.beta ? "google-beta" : "google" }"
  provider = "google-beta"

  count      = "${var.online ? 1 : 0 }"
  name       = "${var.name}"
  cluster    = "${var.cluster}"
  node_count = "${var.online ? var.node_count : 0 }"
  version    = "${var.kubernetes_version}"

  # depends_on = ["google_container_cluster.lab"]
  management {
    auto_upgrade = true
    auto_repair  = true
  }

  node_config {
    /* "UBUNTU", "COS", "COS_CONTAINERD" */
    image_type   = "${var.image_type}"
    machine_type = "${var.machine_type}"
    disk_size_gb = "${var.disk_size_gb}"
    preemptible  = "${var.preemptible}"

    taint  = "${var.taints}"
    labels = "${var.labels}"

    workload_metadata_config {
      node_metadata = "${var.metadata_proxy ? "SECURE" : "EXPOSE" }"
    }

    /* node identity */
    service_account = "${var.service_account}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  timeouts {
    create = "30m"
    delete = "30m"
  }
}
