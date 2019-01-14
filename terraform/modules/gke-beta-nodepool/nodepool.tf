resource "google_container_node_pool" "lab" {
  # https://github.com/hashicorp/terraform/issues/18682
  # provider = "${var.nodepool_config["beta"] ? "google-beta" : "google" }"
  provider = "google-beta"

  count      = "${var.nodepool_config["online"] ? 1 : 0 }"
  name       = "${var.nodepool_config["name"]}"
  cluster    = "${var.nodepool_config["cluster"]}"
  node_count = "${var.nodepool_config["online"] ? var.nodepool_config["node_count"] : 0 }"
  version    = "${var.nodepool_config["kubernetes_version"]}"

  # depends_on = ["google_container_cluster.lab"]

  node_config {
    /* "UBUNTU", "COS", "COS_CONTAINERD" */
    image_type   = "${var.nodepool_config["image_type"]}"
    machine_type = "${var.nodepool_config["machine_type"]}"
    disk_size_gb = "${var.nodepool_config["disk_size_gb"]}"
    preemptible  = "${var.nodepool_config["preemptible"]}"

    /* prefer workloads that tolerate the stability
    of nodes that are not preemptible
    taint = [{
      key    = "stable"
      value  = "true"
      effect = "PREFER_NO_SCHEDULE"
    }]
    */

    workload_metadata_config {
      node_metadata = "${var.nodepool_config["metadata_proxy"] ? "SECURE" : "EXPOSE" }"
    }
    /* node identity */
    service_account = "${var.nodepool_config["service_account"]}"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  timeouts {
    create = "30m"
    delete = "30m"
  }
}
