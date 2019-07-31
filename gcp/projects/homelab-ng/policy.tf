# allUsers needs this :(
resource "google_project_organization_policy" "allow_all_domains" {
  project    = data.google_client_config.current.project
  constraint = "iam.allowedPolicyMemberDomains"

  list_policy {
    inherit_from_parent = false
    allow {
      all = true
    }
  }
}

resource "google_project_organization_policy" "allow_production_services" {
  constraint = "serviceuser.services"
  project    = data.google_client_config.current.project

  list_policy {
    inherit_from_parent = false
    suggested_value     = "dns.googleapis.com"
    allow {
      all = true
    }
  }
}

# cloudfunctions needs to create the project@appspot.gserviceaccount.com account
resource "google_project_organization_policy" "allow_service_accounts" {
  constraint = "iam.disableServiceAccountCreation"
  project    = data.google_client_config.current.project
  boolean_policy {
    enforced = false
  }
}

# we can't deploy functions in canada yet :(
resource "google_project_organization_policy" "allowed_locations" {
  constraint = "constraints/gcp.resourceLocations"
  project    = data.google_client_config.current.project

  list_policy {
    inherit_from_parent = true
    allow {
      values = [
        "us-east4",
      ]
    }
  }
}
