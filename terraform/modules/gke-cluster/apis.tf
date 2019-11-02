resource "google_project_service" "container" {
  service                    = "container.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_project_service" "containerregistry" {
  service                    = "containerregistry.googleapis.com"
  disable_dependent_services = true
  depends_on                 = ["google_project_service.container"]
}

resource "google_project_service" "deploymentmanager" {
  service                    = "deploymentmanager.googleapis.com"
  disable_dependent_services = true
  depends_on                 = ["google_project_service.container"]
}

resource "google_project_service" "replicapool" {
  service                    = "replicapool.googleapis.com"
  depends_on                 = ["google_project_service.container"]
  disable_dependent_services = true
}

resource "google_project_service" "replicapoolupdater" {
  service                    = "replicapoolupdater.googleapis.com"
  depends_on                 = ["google_project_service.container"]
  disable_dependent_services = true
}

resource "google_project_service" "resourceviews" {
  service                    = "resourceviews.googleapis.com"
  depends_on                 = ["google_project_service.container"]
  disable_dependent_services = true
}

/* idk if this is a thing yet */
resource "google_project_service" "bigquery-json" {
  service                    = "bigquery-json.googleapis.com"
  depends_on                 = ["google_project_service.container"]
  disable_dependent_services = true
}
