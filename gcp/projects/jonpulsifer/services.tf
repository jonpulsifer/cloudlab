resource "google_project_service" "project" {
  service                    = "sourcerepo.googleapis.com"
  disable_dependent_services = true
}
