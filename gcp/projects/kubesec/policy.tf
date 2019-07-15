// workload identity requires this to be a thing :(
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

resource "google_project_organization_policy" "allow_service_accounts" {
  constraint = "iam.disableServiceAccountCreation"
  project    = data.google_client_config.current.project
  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "allow_service_account_keys" {
  constraint = "iam.disableServiceAccountKeyCreation"
  project    = data.google_client_config.current.project

  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "allow_production_services" {
  constraint = "serviceuser.services"
  project    = data.google_client_config.current.project

  list_policy {
    allow {
      all = true
    }
  }
}

resource "google_project_organization_policy" "trusted_image_projects" {
  constraint = "compute.trustedImageProjects"
  project    = data.google_client_config.current.project

  list_policy {
    inherit_from_parent = true
    allow {
      values = [
        "projects/cos-cloud",
        "projects/gke-node-images",
        "projects/ubuntu-os-cloud",
        "projects/ubuntu-os-gke-cloud"
      ]
    }
  }
}

resource "google_project_organization_policy" "allowed_locations" {
  constraint = "constraints/gcp.resourceLocations"
  project    = data.google_client_config.current.project

  list_policy {
    inherit_from_parent = true
    allow {
      values = [
        "us-east4-b",
        "us-east4",
      ]
    }
  }
}

resource "google_project_organization_policy" "allow_external_ips" {
  constraint = "constraints/compute.vmExternalIpAccess"
  project    = data.google_client_config.current.project
  list_policy {
    allow {
      all = true
    }
  }
}

resource "google_project_organization_policy" "allow_non_shielded_vm" {
  project    = data.google_client_config.current.project
  constraint = "constraints/compute.requireShieldedVm"
  boolean_policy {
    enforced = false
  }
}
