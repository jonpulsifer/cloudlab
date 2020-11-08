resource "google_organization_policy" "restrict_iam_to_org_domain" {
  org_id     = data.google_organization.org.org_id
  constraint = "iam.allowedPolicyMemberDomains"

  list_policy {
    suggested_value = data.google_organization.org.domain

    allow {
      values = [data.google_organization.org.directory_customer_id]
    }
  }
}

resource "google_organization_policy" "restrict_storage_access" {
  org_id     = data.google_organization.org.org_id
  constraint = "constraints/compute.storageResourceUseRestrictions"
  list_policy {
    deny {
      all = true
    }
  }
}

resource "google_organization_policy" "allowed_locations" {
  org_id     = data.google_organization.org.org_id
  constraint = "constraints/gcp.resourceLocations"
  list_policy {
    allow {
      values = [
        "in:northamerica-northeast1-locations"
      ]
    }
  }
}

resource "google_organization_policy" "no_external_ips" {
  org_id     = data.google_organization.org.org_id
  constraint = "constraints/compute.vmExternalIpAccess"
  list_policy {
    deny {
      all = true
    }
  }
}

resource "google_organization_policy" "require_shielded_vm" {
  org_id     = data.google_organization.org.org_id
  constraint = "constraints/compute.requireShieldedVm"
  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "no_nested_virt" {
  org_id     = data.google_organization.org.org_id
  constraint = "constraints/compute.disableNestedVirtualization"
  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "disable_guest_attributes" {
  org_id     = data.google_organization.org.org_id
  constraint = "constraints/compute.disableGuestAttributesAccess"
  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "no_serial_port_access" {
  org_id     = data.google_organization.org.org_id
  constraint = "constraints/compute.disableSerialPortAccess"
  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "no_serial_port_logging" {
  org_id     = data.google_organization.org.org_id
  constraint = "constraints/compute.disableSerialPortLogging"
  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "trusted_image_projects" {
  org_id     = data.google_organization.org.org_id
  constraint = "compute.trustedImageProjects"

  list_policy {
    allow {
      values = [
        "projects/trusted-builds",
        "projects/secure-the-cloud",
        "projects/cos-cloud",
        "projects/ubuntu-os-cloud",
      ]
    }
  }
}

resource "google_organization_policy" "bucket_policy_no_acls" {
  org_id     = data.google_organization.org.org_id
  constraint = "storage.uniformBucketLevelAccess"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "no_default_networks" {
  org_id     = data.google_organization.org.org_id
  constraint = "compute.skipDefaultNetworkCreation"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "no_service_accounts" {
  org_id     = data.google_organization.org.org_id
  constraint = "iam.disableServiceAccountCreation"
  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "no_service_account_keys" {
  org_id     = data.google_organization.org.org_id
  constraint = "iam.disableServiceAccountKeyCreation"
  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "block_services_because_reasons" {
  org_id     = data.google_organization.org.org_id
  constraint = "serviceuser.services"

  list_policy {
    deny {
      values = [
        "compute.googleapis.com",
        "deploymentmanager.googleapis.com",
        "dns.googleapis.com",
        "doubleclicksearch.googleapis.com",
        "replicapool.googleapis.com",
        "replicapoolupdater.googleapis.com",
        "resourceviews.googleapis.com",
      ]
    }
  }
}
