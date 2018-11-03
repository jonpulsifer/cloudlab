resource "google_container_node_pool" "standard" {
  /* https://github.com/hashicorp/terraform/issues/18682
      provider = "${var.cluster_config["beta"] ? "google-beta" : "google" }" */
  provider = "google-beta"

  count      = "${var.cluster_config["online"] ? 1 : 0 }"
  name       = "standard"
  cluster    = "${google_container_cluster.lab.name}"
  node_count = "${var.cluster_config["online"] ? 1 : var.cluster_config["node_count"] }"
  version    = "${data.google_container_engine_versions.lab.latest_node_version}"
  depends_on = ["google_container_cluster.lab"]

  node_config {
    /* "UBUNTU" or "COS" */
    image_type   = "COS"
    machine_type = "${var.cluster_config["machine_type"]}"
    disk_size_gb = "${var.cluster_config["disk_size_gb"]}"
    preemptible  = "${var.cluster_config["preemptible"]}"

    /* prefer workloads that tolerate the stability
    of nodes that are not preemptible
    taint = [{
      key    = "stable"
      value  = "true"
      effect = "PREFER_NO_SCHEDULE"
    }]
    */

    workload_metadata_config {
      node_metadata = "${var.cluster_config["metadata_proxy"] ? "SECURE" : "EXPOSE" }"
    }
    /* node identity */
    service_account = "${google_service_account.nodes.email}"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  timeouts {
    create = "10m"
    delete = "10m"
  }
}
