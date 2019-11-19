resource "google_project_service" "clouddns" {
  service = "dns.googleapis.com"
  disable_dependent_services = true
}
