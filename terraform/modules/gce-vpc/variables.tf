data "google_client_config" "current" {}
variable "name" {
  type        = "string"
  description = "The name for the network"
  default     = "lab"
}

variable "vm_cidr" {
  type        = "string"
  description = "The default CIDR for the cloudlab VMs"
  default     = "10.13.37.0/28"
}

variable "private_api_access" {
  description = "Access to Google APIs over RFC1918 networks"
  default     = true
}

variable "enable_flow_logs" {
  description = "Collect flow logs on the VPC"
  default     = false
}
