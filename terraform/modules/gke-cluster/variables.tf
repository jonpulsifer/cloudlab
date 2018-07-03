variable "name" {
  description = "Prefix of the cluster resources"
  default     = "lab"
}

variable "cluster_config" {
  type = "map"

  default = {
    online       = false
    node_count   = 1
    machine_type = "n1-standard-1"
    alpha        = false
    preemptible  = true

    node_cidr    = "10.0.0.0/24"
    service_cidr = "10.1.0.0/24"
    pod_cidr     = "10.2.0.0/19"
  }
}
