variable "name" {
  description = "Prefix of the cluster resources"
  default     = "lab"
}

variable "network_policy" {
  description = "Enable Network Policy"
  default     = true
}

variable "pod_security_policy" {
  description = "Enable Pod Security Policy"
  default     = true
}

variable "google_cloud_load_balancer" {
  description = "Enable Google Cloud Load Balancer"
  default     = false
}

variable "istio" {
  description = "Enable Istio"
  default     = true
}

variable "istio_strict_mtls" {
  description = "Istio MTLS behavior: MTLS_PERMISSIVE or MTLS_STRICT"
  default     = ""
}

variable "binary_authorization" {
  description = "Enable Binary Authorization"
  default     = true
}

variable "logging_service" {
  description = "Logging Service for the cluster, one of logging.googleapis.com, logging.googleapis.com/kubernetes, or none"
  default     = "none"
}

variable "kubernetes_version" {
  description = "Default Kubernetes version for the master"
  default     = "1.11.6-gke.6"
}

variable "network_config" {
  description = "VPC network configuration for the cluster"
  type        = "map"

  default = {
    node_cidr    = "10.0.0.0/24"
    service_cidr = "10.1.0.0/24"
    pod_cidr     = "10.2.0.0/19"
  }
}

variable "labels" {
  type    = "map"
  default = {}
}
