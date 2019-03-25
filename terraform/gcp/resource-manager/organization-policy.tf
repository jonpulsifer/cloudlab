resource "google_organization_policy" "restrict_iam_to_org_domain" {
  org_id     = "${data.google_organization.org.id}"
  constraint = "iam.allowedPolicyMemberDomains"

  list_policy {
    suggested_value = "${data.google_organization.org.domain}"

    allow {
      values = ["${data.google_organization.org.directory_customer_id}"]
    }
  }
}

resource "google_organization_policy" "trusted_image_projects" {
  org_id     = "${data.google_organization.org.id}"
  constraint = "compute.trustedImageProjects"

  list_policy {
    allow {
      values = [
        "projects/trusted-builds",
        "projects/secure-the-cloud",
      ]
    }
  }
}

resource "google_organization_policy" "bucket_policy_no_acls" {
  org_id     = "${data.google_organization.org.id}"
  constraint = "storage.bucketPolicyOnly"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "no_default_networks" {
  org_id     = "${data.google_organization.org.id}"
  constraint = "compute.skipDefaultNetworkCreation"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "no_service_accounts" {
  org_id     = "${data.google_organization.org.id}"
  constraint = "iam.disableServiceAccountCreation"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "no_service_account_keys" {
  org_id     = "${data.google_organization.org.id}"
  constraint = "iam.disableServiceAccountKeyCreation"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "block_services_because_reasons" {
  org_id     = "${data.google_organization.org.id}"
  constraint = "serviceuser.services"

  list_policy {
    deny {
      values = [
        "compute.googleapis.com",
        "doubleclicksearch.googleapis.com",
        "deploymentmanager.googleapis.com",
      ]
    }
  }
}