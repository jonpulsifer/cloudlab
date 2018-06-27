variable "billing_account" {
  description = "The billing account ID for this project"
  default     = ""
}

variable "name" {
  description = "The human readable project name (min 4 letters)"
  default     = "Terraform Project - Change Me"
}

variable "project_id" {
  description = "The GCP project ID"
  default     = ""
}

variable "folder_id" {
  description = "The GCP folder housing the project"
  default     = ""
}

variable "org_id" {
  description = "The GCP organization that owns the project"
  default     = ""
}

variable "auto_create_network" {
  description = "Automatically provision a default global VPC network"
  default     = false
}

variable "skip_delete" {
  description = "skips deleting the project from GCP (only deletes from tf)"
  default     = true
}
