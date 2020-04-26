data "google_iam_policy" "explicit" {
  binding {
    role    = "roles/cloudfunctions.serviceAgent"
    members = ["serviceAccount:service-629296473058@gcf-admin-robot.iam.gserviceaccount.com"]
  }


  binding {
    role    = "roles/editor"
    members = ["serviceAccount:629296473058@cloudservices.gserviceaccount.com"]
  }

  binding {
    role    = "roles/owner"
    members = ["user:jonathan@pulsifer.ca"]
  }

  binding {
    role    = "roles/dns.admin"
    members = [join(":", ["serviceAccount", google_service_account.ddns.email])]
  }

  binding {
    role    = "roles/monitoring.metricWriter"
    members = [join(":", ["serviceAccount", google_service_account.ddns.email])]
  }

  binding {
    role    = "roles/logging.logWriter"
    members = [join(":", ["serviceAccount", google_service_account.ddns.email])]
  }

  binding {
    role    = "roles/cloudtrace.agent"
    members = [join(":", ["serviceAccount", google_service_account.ddns.email])]
  }

  binding {
    role    = "roles/errorreporting.writer"
    members = [join(":", ["serviceAccount", google_service_account.ddns.email])]
  }

  binding {
    role    = "roles/compute.viewer"
    members = [join(":", ["serviceAccount", google_service_account.datadog.email])]
  }

  binding {
    role    = "roles/monitoring.viewer"
    members = [join(":", ["serviceAccount", google_service_account.datadog.email])]
  }

  binding {
    role    = "roles/cloudasset.viewer"
    members = [join(":", ["serviceAccount", google_service_account.datadog.email])]
  }
}

resource "google_project_iam_policy" "explicit" {
  project     = data.google_client_config.current.project
  policy_data = data.google_iam_policy.explicit.policy_data
}

resource "google_service_account" "ddns" {
  account_id = "ddns-function"
}

resource "google_service_account" "datadog" {
  account_id = "datadog"
}
