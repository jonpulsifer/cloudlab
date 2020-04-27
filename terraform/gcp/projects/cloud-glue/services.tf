resource "google_project_service" "service" {
  for_each = toset([
    "appsmarket-component.googleapis.com",
    "bigquery.googleapis.com",
    "cloudfunctions.googleapis.com",
    "compute.googleapis.com",
    "dataflow.googleapis.com",
    "logging.googleapis.com",
    "pubsub.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com"
  ])

  service = each.key

  disable_on_destroy = false
}
