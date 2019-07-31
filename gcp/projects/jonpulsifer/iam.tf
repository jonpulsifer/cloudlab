

data "google_iam_policy" "explicit" {
  binding {
    role = "roles/owner"
    members = [
      "user:jonathan@pulsifer.ca",
    ]
  }
  binding {
    role    = "roles/sourcerepo.serviceAgent"
    members = ["serviceAccount:service-254228897527@sourcerepo-service-accounts.iam.gserviceaccount.com", ]
  }
}

resource "google_project_iam_policy" "explicit" {
  project     = data.google_client_config.current.project
  policy_data = data.google_iam_policy.explicit.policy_data
}
