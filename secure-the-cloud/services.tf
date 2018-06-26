resource "google_project_services" "secure-the-cloud" {
  project = "${var.gcp_config["project_id"]}"

  services = [
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "oslogin.googleapis.com",
  ]
}
