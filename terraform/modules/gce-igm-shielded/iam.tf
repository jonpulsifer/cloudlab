resource "google_service_account" "igm" {
  account_id   = "${var.name}-igm"
  display_name = "service account for ${var.name} GCE Shielded VM"
}

resource "google_project_iam_member" "logging" {
  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.igm.email}"
}

resource "google_project_iam_member" "tracing" {
  role   = "roles/cloudtrace.agent"
  member = "serviceAccount:${google_service_account.igm.email}"
}

resource "google_project_iam_member" "debugging" {
  role   = "roles/clouddebugger.agent"
  member = "serviceAccount:${google_service_account.igm.email}"
}

resource "google_project_iam_member" "profiling" {
  role   = "roles/cloudprofiler.agent"
  member = "serviceAccount:${google_service_account.igm.email}"
}

resource "google_project_iam_member" "errorreporting" {
  role   = "roles/errorreporting.writer"
  member = "serviceAccount:${google_service_account.igm.email}"
}

resource "google_project_iam_member" "monitoring" {
  role   = "roles/monitoring.metricWriter"
  member = "serviceAccount:${google_service_account.igm.email}"
}

output "service_account" {
  value = google_service_account.igm.email
}

output "service_account_name" {
  value = google_service_account.igm.name
}
