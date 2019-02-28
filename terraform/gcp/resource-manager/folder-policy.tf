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

resource "google_folder_organization_policy" "trusted_image_projects" {
  folder     = "${google_folder.production.name}"
  constraint = "compute.trustedImageProjects"

  list_policy {
    inherit_from_parent = true

    allow {
      values = [
        "projects/gke-node-images",
        "projects/ubuntu-os-gke-cloud",
      ]
    }
  }
}
