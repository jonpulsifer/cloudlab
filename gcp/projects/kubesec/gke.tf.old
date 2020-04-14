data "google_container_engine_versions" "cloudlab" {}
module "gke-controlplane" {
  source   = "github.com/jonpulsifer/terraform-modules//gke-cluster"
  name     = "seawall"
  project  = local.project
  location = local.region

  kubernetes_version = data.google_container_engine_versions.cloudlab.latest_master_version

  monitoring_service         = "none"
  logging_service            = "none"
  google_cloud_load_balancer = true
  network_config = {
    enable_ssh     = true
    enable_natgw   = true
    private_master = false
    private_nodes  = true
    node_cidr      = "10.0.0.0/24"
    service_cidr   = "10.10.0.0/16"
    pod_cidr       = "10.100.0.0/19"
    master_cidr    = "192.168.0.0/28"
  }

  master_authorized_networks = {
    cidr_block   = "0.0.0.0/0"
    display_name = "internet"
  }

  labels = {
    environment = "dev"
  }
}

module "ubuntu-nodes" {
  source = "github.com/jonpulsifer/terraform-modules//gke-nodepool"

  name               = "buntu"
  cluster            = module.gke-controlplane.name
  location           = local.region
  node_count         = 1
  image_type         = "UBUNTU_CONTAINERD"
  kubernetes_version = data.google_container_engine_versions.cloudlab.latest_master_version
  service_account    = module.gke-controlplane.node_service_account
  machine_type       = "e2-standard-2"
  disk_size_gb       = 24
  preemptible        = true
  labels = {
    environment = "production"
    os          = "ubuntu"
    runtime     = "docker"
  }
}
