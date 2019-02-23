variable "name" {
  description = "Prefix of the cluster resources"
  default     = "lab"
}

variable "cluster_config" {
  type = "map"

  default = {
    online               = false
    beta                 = true
    alpha                = false
    network_policy       = true
    istio                = true
    binary_authorization = true
    kubernetes_version   = "1.11.6-gke.6"
    node_cidr            = "10.0.0.0/24"
    service_cidr         = "10.1.0.0/24"
    pod_cidr             = "10.2.0.0/19"
  }
}
