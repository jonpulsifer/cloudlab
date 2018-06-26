variable "gcp_config" {
  type = "map"
}

resource "google_project_iam_policy" "project" {
  project     = "${var.gcp_config["project_id"]}"
  policy_data = "${data.google_iam_policy.project.policy_data}"
}

data "google_iam_policy" "project" {
  binding {
    role = "roles/editor"

    members = [
      "serviceAccount:${var.gcp_config["project_number"]}@cloudservices.gserviceaccount.com",
    ]
  }

  binding {
    role = "roles/compute.serviceAgent"

    members = [
      "serviceAccount:service-${var.gcp_config["project_number"]}@compute-system.iam.gserviceaccount.com",
    ]
  }

  binding {
    role = "roles/logging.logWriter"

    members = [
      "serviceAccount:${google_service_account.vm.email}",
    ]
  }

  binding {
    role = "roles/monitoring.metricWriter"

    members = [
      "serviceAccount:${google_service_account.vm.email}",
    ]
  }
}
