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
    "google_kms_crypto_key.gke",
  ]

  # GKE Cluster name
  name = var.name

  # human readable description of this cluster
  description = "${var.name} GKE cluster"

  # where the cluster will run
  location = var.location

  # google groups for rbac
  authenticator_groups_config {
    security_group = (var.rbac_group_domain != "" ? join("@", ["gke-security-groups", var.rbac_group_domain]) : var.rbac_group_domain)
  }

  # use the latest GKE release for the master and worker nodes and set the release channel
  min_master_version = var.kubernetes_version
  release_channel {
    channel = var.release_channel
  }

  resource_labels = var.labels

  # GKE requires a node pool to be created on creation
  initial_node_count = 1
  # but we do not like that
  remove_default_node_pool = true

  # stackdriver is super expensive
  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  # so is cluster autoscaling
  cluster_autoscaling {
    enabled = false
  }

  # inherit the network from terraform
  network    = google_compute_network.gke.self_link
  subnetwork = google_compute_subnetwork.nodes.name

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config {
    enable_private_endpoint = var.network_config["private_master"]
    enable_private_nodes    = var.network_config["private_nodes"]
    master_ipv4_cidr_block  = var.network_config["master_cidr"]
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "internetz"
    }
  }

  # use shielded (uefi) nodes
  enable_shielded_nodes = var.shielded_nodes

  # encrypt etcd
  database_encryption {
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.gke.id
  }

  /* enable NetworkPolicy */
  network_policy {
    enabled  = var.network_policy
    provider = var.network_policy ? "CALICO" : "PROVIDER_UNSPECIFIED"
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
    enabled = var.pod_security_policy
  }

  /* enable binauthz */
  enable_binary_authorization = var.binary_authorization

  /* workload identity */
  workload_identity_config {
    identity_namespace = join(".", [data.google_client_config.current.project, "svc.id.goog"])
  }

  addons_config {
    http_load_balancing {
      disabled = var.google_cloud_load_balancer ? false : true
    }

    # explicitly disable kubernetes dashboard
    kubernetes_dashboard {
      disabled = true
    }

    horizontal_pod_autoscaling {
      disabled = var.hpa ? false : true
    }

    network_policy_config {
      disabled = var.network_policy ? false : true
    }

    istio_config {
      auth     = var.istio ? "AUTH_MUTUAL_TLS" : "AUTH_NONE"
      disabled = var.istio ? false : true
    }

    # cloudrun requires istio, so misel
    cloudrun_config {
      disabled = var.istio ? false : true
    }
  }
}

output "name" {
  value = var.name
}

output "version" {
  value = var.kubernetes_version
}
