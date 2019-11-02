data "google_client_config" "current" {}
data "google_project" "current" {
  project_id = data.google_client_config.current.project
}

variable "name" {
  description = "Prefix of the cluster resources"
  type        = string
  default     = "lab"
}

variable "location" {
  description = "Location of the cluster (region or zone)"
  type        = string
  default     = ""
}

variable "network_policy" {
  description = "Enable Network Policy"
  type        = bool
  default     = true
}

variable "hpa" {
  description = "Enable Horizontal Pod Autoscaling"
  type        = bool
  default     = false
}

variable "kms_key_ring" {
  description = "Name of the KMS key ring used to encrypt etcd"
  type        = string
  default     = null
}

variable "release_channel" {
  description = "Release cadence of the GKE cluster"
  type        = string
  default     = "RAPID"
}

variable "shielded_nodes" {
  description = "Forces node pools to use shielded (uefi) images"
  type        = bool
  default     = true
}

variable "rbac_group_domain" {
  description = "Google Groups for RBAC requires a G Suite domain"
  type        = string
  default     = "pulsifer.ca"
}

variable "pod_security_policy" {
  description = "Enable Pod Security Policy"
  type        = bool
  default     = true
}

variable "google_cloud_load_balancer" {
  description = "Enable Google Cloud Load Balancer"
  type        = bool
  default     = false
}

variable "istio" {
  description = "Enable Istio"
  type        = bool
  default     = false
}

variable "cloudrun" {
  description = "Enable Cloud Run on GKE (requires istio)"
  type        = bool
  default     = false
}

variable "istio_strict_mtls" {
  description = "Istio MTLS behavior: MTLS_PERMISSIVE or MTLS_STRICT"
  type        = string
  default     = "MTLS_STRICT"
}

variable "binary_authorization" {
  description = "Enable Binary Authorization"
  type        = bool
  default     = true
}

variable "monitoring_service" {
  description = "Monitoring Service for the cluster, one of monitoring.googleapis.com/kubernetes, or none"
  type        = string
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "logging_service" {
  description = "Logging Service for the cluster, one of logging.googleapis.com, logging.googleapis.com/kubernetes, or none"
  type        = string
  default     = "logging.googleapis.com/kubernetes"
}

variable "kubernetes_version" {
  description = "Default Kubernetes version for the master"
  type        = string
  default     = "1.11.6-gke.6"
}

variable "network_config" {
  description = "VPC network configuration for the cluster"
  type        = map

  default = {
    enable_natgw   = false
    enable_ssh     = false
    private_master = true
    private_nodes  = true
    node_cidr      = "10.0.0.0/24"
    service_cidr   = "10.1.0.0/24"
    pod_cidr       = "10.2.0.0/24"
    master_cidr    = "10.20.30.0/28"
  }
}

variable "master_authorized_networks" {
  description = "Map of cidrs that can access the master network"
  type        = map
  default     = {}
}

variable "labels" {
  description = "List of Kubernetes labels to apply to the nodes"
  type        = map
  default     = {}
}
