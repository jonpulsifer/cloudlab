/* create and configure a GKE cluster */
resource "google_container_cluster" "lab" {
  # https://github.com/hashicorp/terraform/issues/18682
  # provider = "${var.beta ? "google-beta" : "google" }"
  provider = "google-beta"

  /* GKE requires the API, a  network, subnet, and service account */
  depends_on = [
    "google_project_service.container",
    "google_service_account.nodes",
    "google_compute_network.gke",
    "google_compute_subnetwork.nodes",
  ]

  /* GKE Cluster name */
  name = "${var.name}"

  # count = "${var.online ? 1 : 0 }"

  /* Human readable description of this cluster */
  description = "${var.name} GKE cluster"
  /* Use the latest GKE release for the master and worker nodes */
  min_master_version = "${var.kubernetes_version}"
  # node_version       = "${var.kubernetes_version}"
  /* GKE requires a node pool to be created on creation */
  initial_node_count = 1
  /* and we require to :nuke: it */
  remove_default_node_pool = true
  resource_labels          = "${var.labels}"
  logging_service          = "${coalesce(var.logging_service,"none")}"
  # this is super expensive
  monitoring_service = "none"
  /* inherit the network from terraform */
  network    = "${google_compute_network.gke.self_link}"
  subnetwork = "${google_compute_subnetwork.nodes.name}"
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
  /* enable NetworkPolicy */
  network_policy {
    enabled  = "${var.network_policy}"
    provider = "${var.network_policy ? "CALICO" : "PROVIDER_UNSPECIFIED" }"
  }
  /* disable basic authentication */
  master_auth {
    username = ""
    password = ""

    /* disable client certificate */
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  /* disable the ABAC authorizer */
  enable_legacy_abac = "false"
  /* enable PodSecurityPolicy */
  pod_security_policy_config {
    enabled = "${coalesce(var.pod_security_policy,"true")}"
  }
  /* enable Binary Authorization */
  enable_binary_authorization = "${coalesce(var.binary_authorization,"true")}"
  /* disable the Kubernetes dashboard */
  addons_config {
    http_load_balancing {
      disabled = "${var.google_cloud_load_balancer ? false : true }"
    }

    kubernetes_dashboard {
      disabled = true
    }

    horizontal_pod_autoscaling {
      disabled = true
    }

    network_policy_config {
      disabled = "${var.network_policy ? false : true }"
    }

    istio_config {
      disabled = "${var.istio ? false : true }"
    }
  }
}

output "name" {
  value = "${var.name}"
}

output "version" {
  value = "${var.kubernetes_version}"
}
