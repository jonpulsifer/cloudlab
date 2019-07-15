variable "online" {
  default = false
}

variable "name" {
  default = "labpool"
}

variable "node_count" {
  default = 1
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
  default = "EXPOSE"
}

variable "taints" {
  type    = "list"
  default = []
}

variable "labels" {
  type    = "map"
  default = {}
}
