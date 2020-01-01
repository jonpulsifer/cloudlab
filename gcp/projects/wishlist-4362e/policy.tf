resource "google_project_organization_policy" "allow_production_services" {
  project    = local.project
  constraint = "serviceuser.services"

  list_policy {
    allow {
      all = true
    }
  }
}

resource "google_project_organization_policy" "allow_service_accounts" {
  project    = local.project
  constraint = "iam.disableServiceAccountCreation"
  boolean_policy {
    enforced = false
  }
}
