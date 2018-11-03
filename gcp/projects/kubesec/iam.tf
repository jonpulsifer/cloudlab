resource "google_project_iam_member" "cloudservices" {
  role   = "roles/editor"
  member = "serviceAccount:${google_project.kubesec.number}@cloudservices.gserviceaccount.com"
}

resource "google_project_iam_member" "compute-default" {
  role   = "roles/editor"
  member = "serviceAccount:${google_project.kubesec.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "compute-system" {
  role   = "roles/compute.serviceAgent"
  member = "serviceAccount:service-${google_project.kubesec.number}@compute-system.iam.gserviceaccount.com"
}

resource "google_storage_bucket_iam_binding" "cloudbuild" {
  bucket = "cloud-lab"
  role   = "roles/storage.admin"

  members = [
    "serviceAccount:821879192255@cloudbuild.gserviceaccount.com",
  ]
}

# resource "google_storage_bucket_iam_binding" "cloudlab-vm" {
#   bucket = "cloud-lab"
#   role   = "roles/storage.objectViewer"

#   members = ["serviceAccount:${module.cos-vm.service_account}"]
# }

resource "google_service_account" "wishlist" {
  account_id   = "wishlist"
  display_name = "service account for wishlist rails app"
}

resource "google_project_iam_member" "vm-logging" {
  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.wishlist.email}"
}

resource "google_project_iam_member" "vm-tracing" {
  role   = "roles/cloudtrace.agent"
  member = "serviceAccount:${google_service_account.wishlist.email}"
}

resource "google_project_iam_member" "vm-debugging" {
  role   = "roles/clouddebugger.agent"
  member = "serviceAccount:${google_service_account.wishlist.email}"
}

resource "google_project_iam_member" "vm-profiling" {
  role   = "roles/cloudprofiler.agent"
  member = "serviceAccount:${google_service_account.wishlist.email}"
}

resource "google_project_iam_member" "vm-errorreporting" {
  role   = "roles/errorreporting.writer"
  member = "serviceAccount:${google_service_account.wishlist.email}"
}

resource "google_project_iam_member" "vm-monitoring" {
  role   = "roles/monitoring.metricWriter"
  member = "serviceAccount:${google_service_account.wishlist.email}"
}
