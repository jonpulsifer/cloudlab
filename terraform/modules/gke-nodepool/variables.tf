variable "name" {
  default = "labpool"
}

variable "node_count" {
  default = 0
}

variable "image_type" {
  default = "COS_CONTAINERD"
}

variable "disk_size_gb" {
  default = 10
}

variable "kubernetes_version" {
  default = "1.11.6-gke.0"
}

variable "cluster" {
  default = "yourcluster"
}

variable "machine_type" {
  default = "custom-1-1"
}

variable "service_account" {
  default = "foo@your-project.iam.gserviceaccount.com"
}

variable "preemptible" {
  default = true
}

variable "node_metadata" {
  description = "Adjusts the node metadata service, one of: GKE_METADATA_SERVER, SECURE, or EXPOSE"
  type        = string
  default     = "GKE_METADATA_SERVER"
}

variable "taints" {
  type    = "list"
  default = []
}

variable "labels" {
  type    = "map"
  default = {}
}
variable "shielded" {
  description = "Forces the nodes to use shielded (uefi) images and enables secure boot"
  type        = bool
  default     = true
}
