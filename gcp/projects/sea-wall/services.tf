resource "google_project_service" "compute" {
  service                    = "compute.googleapis.com"
  disable_dependent_services = true
}
