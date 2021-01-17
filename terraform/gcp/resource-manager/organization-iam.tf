resource "google_organization_iam_policy" "organization" {
  org_id      = data.google_organization.org.org_id
  policy_data = data.google_iam_policy.org.policy_data
}

data "google_iam_policy" "org" {
  binding {
    role = "roles/resourcemanager.organizationPolicyAdmin"

    members = [
      "group:cloud@pulsifer.ca",
    ]
  }

  binding {
    role = "roles/securitycenter.serviceAgent"

    members = [
      "serviceAccount:service-org-5046617773@security-center-api.iam.gserviceaccount.com",
    ]
  }
}
