# fetch the latest GKE versions for the zone
data "google_container_engine_versions" "lab" {
  depends_on = ["google_project_service.container"]
}

# create and configure a GKE cluster
resource "google_container_cluster" "lab" {
  # GKE requires a network, subnet, and service account
  depends_on = [
    "google_project_service.container",
    "google_service_account.nodes",
    "google_compute_network.gke",
    "google_compute_subnetwork.nodes",
  ]

  # GKE Cluster name
  name  = "${var.name}"
  count = "${var.cluster_config["online"] ? 1 : 0 }"

  # Human readable description of this cluster
  description = "${var.name} GKE cluster"

  # Use the latest GKE release for the master and worker nodes
  min_master_version = "${data.google_container_engine_versions.lab.latest_node_version}"
  node_version       = "${data.google_container_engine_versions.lab.latest_node_version}"

  # inherit the network from terraform
  network    = "${google_compute_network.gke.self_link}"
  subnetwork = "${google_compute_subnetwork.nodes.name}"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  # enable NetworkPolicy
  network_policy {
    enabled  = "true"
    provider = "CALICO"
  }

  # disable the ABAC authorizer
  enable_legacy_abac = "false"

  # disable basic authentication
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # enable PodSecurityPolicy
  pod_security_policy_config {
    enabled = "true"
  }

  # disable the Kubernetes dashboard
  addons_config {
    http_load_balancing {
      disabled = true
    }

    kubernetes_dashboard {
      disabled = true
    }

    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  remove_default_node_pool = true

  # GKE requires a node pool to be created on creation
  # how many do you want?
  initial_node_count = 1
}
