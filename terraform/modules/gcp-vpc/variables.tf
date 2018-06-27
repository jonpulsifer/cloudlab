variable "name" {
  description = "The name for the network"
  default     = "lab"
}

variable "vm_cidr" {
  description = "The default CIDR for the cloudlab VMs"
  default     = "10.13.37.0/28"
}

variable "private_api_access" {
  description = "Access to Google APIs over RFC1918 networks"
  default     = true
}
