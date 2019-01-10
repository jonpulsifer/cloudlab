variable "nodepool_config" {
  type = "map"

  default = {
    online             = false
    name               = "labpool"
    node_count         = 1
    image_type         = "COS_CONTAINERD"
    kubernetes_version = "1.11.6-gke.0"
    cluster            = "yourcluster"
    machine_type       = "custom-1-1"
    service_account    = "foo@your-project.iam.gserviceaccount.com"
    preemptible        = true
    metadata_proxy     = true
  }
}
