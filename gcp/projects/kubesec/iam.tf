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

resource "google_storage_bucket_iam_binding" "cloudlab-vm" {
  bucket = "cloud-lab"
  role   = "roles/storage.objectViewer"

  members = ["serviceAccount:${module.cos-vm.service_account}"]
}
