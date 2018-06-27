variable "name" {
  description = "Name for the service account and VM prefix"
  default     = "lab"
}

variable "image_config" {
  type = "map"

  default = {
    family  = "ubuntu-1804-lts"
    project = "trusted-builds"
  }
}

variable "instance_config" {
  type = "map"

  default = {
    online       = false
    machine_type = "n1-standard-1"
    preemptible  = "false"
    subnet       = "10.13.37.0/29"
    mount_point  = "/home/jawn"
    ssd_size     = 10
  }
}
