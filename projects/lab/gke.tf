module "gke" {
  source = "../../terraform/modules/gke-cluster"
  name   = "kubelab"

  cluster_config {
    /* cluster settings */
    online     = false
    node_count = 3
    alpha      = false

    /* node settings */
    machine_type = "n1-standard-1"
    disk_size_gb = 32
    preemptible  = true

    /* network settings */
    node_cidr    = "172.16.0.0/29"
    pod_cidr     = "172.16.32.0/19"
    service_cidr = "172.16.64.0/24"
  }
}
