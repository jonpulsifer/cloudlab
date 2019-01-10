variable "name" {
  description = "Name for the service account and VM prefix"
  default     = "lab"
}
variable "instance_config" {
  type = "map"

  default = {
    online       = false
    machine_type = "n1-standard-1"
    image_family  = "cos-stable"
    image_project = "cos-cloud"
    preemptible  = "false"
    subnet       = "10.13.37.0/29"
    mount_point  = "/mnt/disk2"
    ssd_size     = 10

    cloud_init = <<HEREDOC
#cloud-config
HEREDOC
  }
}

variable "image_config" {
  type = "map"

  default = {
    family  = "${var.instance_config["image_family"]}"
    project = "${var.instance_config["image_project"]}"
  }
}
