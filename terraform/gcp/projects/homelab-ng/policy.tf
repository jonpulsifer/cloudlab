# allUsers needs this :(
resource "google_project_organization_policy" "allow_all_domains" {
  project    = local.project
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
  project    = local.project

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
  project    = local.project
  boolean_policy {
    enforced = false
  }
}

# datadog needs keys
resource "google_project_organization_policy" "allow_service_account_keys" {
  constraint = "iam.disableServiceAccountKeyCreation"
  project    = local.project
  boolean_policy {
    enforced = false
  }
}

# we can't deploy functions in canada yet :(
resource "google_project_organization_policy" "allowed_locations" {
  constraint = "constraints/gcp.resourceLocations"
  project    = local.project

  list_policy {
    inherit_from_parent = true
    allow {
      values = [
        "in:us-east4-locations",
        "us",
      ]
    }
  }
}
