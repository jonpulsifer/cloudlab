resource "google_project_iam_member" "cloud-builder" {
  role   = "roles/cloudbuild.builds.builder"
  member = "serviceAccount:${module.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "instance-admin" {
  role   = "roles/compute.instanceAdmin"
  member = "serviceAccount:${module.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "compute-storage" {
  role   = "roles/compute.storageAdmin"
  member = "serviceAccount:${module.project.number}@cloudbuild.gserviceaccount.com"
}
