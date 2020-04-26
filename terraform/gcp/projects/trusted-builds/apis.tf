resource "google_project_service" "service" {
  for_each = toset([
    "cloudbuild.googleapis.com",
    "compute.googleapis.com",
    "containerregistry.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "oslogin.googleapis.com",
    "pubsub.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "sourcerepo.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com"
  ])

  service            = each.key
  disable_on_destroy = false
}
