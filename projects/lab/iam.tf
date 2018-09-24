resource "google_project_iam_member" "cloudservices" {
  role   = "roles/editor"
  member = "serviceAccount:${google_project.kubesec.number}@cloudservices.gserviceaccount.com"

  lifecycle {
    prevent_destroy = "true"
  }
}

resource "google_project_iam_member" "compute-default" {
  role   = "roles/editor"
  member = "serviceAccount:${google_project.kubesec.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "compute-system" {
  role   = "roles/compute.serviceAgent"
  member = "serviceAccount:service-${google_project.kubesec.number}@compute-system.iam.gserviceaccount.com"
}
