module "dataflow_network" {
  source        = "github.com/jonpulsifer/terraform-modules//gce-vpc"
  name          = "dataflow"
  subnet_name   = "vms"
  ip_cidr_range = "172.16.0.0/28"
  external_ssh  = true
}

resource "google_compute_firewall" "dataflow" {
  name      = "dataflow"
  network   = module.dataflow_network.network.name
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["12345-12346"]
  }
  target_tags = ["dataflow"]
  source_tags = ["dataflow"]
}
