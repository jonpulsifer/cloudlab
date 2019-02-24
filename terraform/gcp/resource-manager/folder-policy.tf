resource "google_folder_organization_policy" "allow_service_accounts" {
  folder     = "${google_folder.production.name}"
  constraint = "iam.disableServiceAccountCreation"

  boolean_policy {
    enforced = false
  }
}

resource "google_folder_organization_policy" "allow_service_account_keys" {
  folder     = "${google_folder.production.name}"
  constraint = "iam.disableServiceAccountKeyCreation"

  boolean_policy {
    enforced = false
  }
}

resource "google_folder_organization_policy" "allow_production_services" {
  folder     = "${google_folder.production.name}"
  constraint = "serviceuser.services"

  list_policy {
    allow {
      all = true
    }
  }
}
