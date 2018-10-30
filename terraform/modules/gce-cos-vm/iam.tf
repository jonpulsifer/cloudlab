resource "google_service_account" "vm" {
  account_id   = "${var.name}"
  display_name = "service account for ${var.name} GCE VM"
}

resource "google_project_iam_member" "vm-logging" {
  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.vm.email}"
}

resource "google_project_iam_member" "vm-monitoring" {
  role   = "roles/monitoring.metricWriter"
  member = "serviceAccount:${google_service_account.vm.email}"
}

output "service_account" {
  value = "${google_service_account.vm.email}"
}
