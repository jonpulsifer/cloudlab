resource "google_service_account" "builder" {
  account_id   = "builder"
  display_name = "Builder VM service account"
}

/*
TODO: open issue on provider for the cloudbuild regex


data "google_iam_policy" "builder" {
  binding {
    role = "roles/serviceAccountUser"

    members = [
      "serviceAccount:821879192255@cloudbuild.gserviceaccount.com",
    ]
  }
}

resource "google_service_account_iam_policy" "builder" {
  service_account_id = "projects/trusted-builds/serviceAccounts/821879192255@cloudbuild.gserviceaccount.com"
  policy_data        = "${data.google_iam_policy.builder.policy_data}"
}

*/

output "builder_service_account" {
  value = "${google_service_account.builder.email}"
}
