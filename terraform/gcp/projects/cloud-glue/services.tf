resource "google_project_service" "marketplace" {
  service                    = "appsmarket-component.googleapis.com"
  disable_dependent_services = true
}
resource "google_project_service" "pubsub" {
  service                    = "pubsub.googleapis.com"
  disable_dependent_services = true
}
