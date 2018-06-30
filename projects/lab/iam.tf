resource "google_project_iam_member" "cloudservices" {
  role   = "roles/editor"
  member = "serviceAccount:${module.project.number}@cloudservices.gserviceaccount.com"

  lifecycle {
    prevent_destroy = "true"
  }
}

resource "google_project_iam_member" "compute-default" {
  role   = "roles/editor"
  member = "serviceAccount:${module.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "compute-system" {
  role   = "roles/compute.serviceAgent"
  member = "serviceAccount:service-${module.project.number}@compute-system.iam.gserviceaccount.com"
}
