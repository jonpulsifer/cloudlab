resource "google_project_organization_policy" "allow_production_services" {
  constraint = "serviceuser.services"
  project    = data.google_client_config.current.project

  list_policy {
    allow {
      all = true
    }
  }
}

resource "google_project_organization_policy" "allow_service_accounts" {
  constraint = "iam.disableServiceAccountCreation"
  project    = data.google_client_config.current.project
  boolean_policy {
    enforced = false
  }
}
