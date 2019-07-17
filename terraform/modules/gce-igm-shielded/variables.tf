data "google_client_config" "current" {}
data "google_project" "current" {
  project_id = data.google_client_config.current.project
}

variable "name" {
  description = "Name for the service account and VM prefix"
  default     = "lab"
}

variable "image_family" {
  type        = "string"
  description = "GCE Image Family e.g. cos-beta, ubuntu-1804-lts"
  default     = "cos-beta"
}

variable "image_project" {
  type        = "string"
  description = "GCE Image Project e.g. gce-uefi-images, trusted-builds"
  default     = "gce-uefi-images"
}

variable "machine_type" {
  type        = "string"
  description = "GCE Machine Type"
  default     = "n1-standard-1"
}

variable "preemptible" {
  type        = "string"
  description = "Toggle if the instance is preemptible. Defaults to true"
  default     = "true"
}

variable "subnet" {
  type        = "string"
  description = "Which subnet to deploy into"
  default     = "10.13.37.0/29"
}

variable "cloud_init" {
  type        = "string"
  description = "the user-data cloud-init script"
  default     = <<HEREDOC
#cloud-config
HEREDOC
}

variable "target_size" {
  description = "Count of instances to create (zonal)"
  default = 1
}

variable "enable_lb" {
  description = "Enables or disables load balancing"
  default = false
}

variable "port_range" {
  description = "Port range for the load balancer"
  default = ""
}

variable "protocol" {
  description = "IP protocol for the load balancer"
  default = "TCP"
}

variable "target_pools" {
  description = "List of the target pools this igm belongs to"
  type = list
  default = []
}
