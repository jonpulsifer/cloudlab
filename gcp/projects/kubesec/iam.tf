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

resource "google_storage_bucket_iam_member" "cloudbuild" {
  bucket = "cloud-lab"
  role   = "roles/storage.admin"

  member = "serviceAccount:821879192255@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild" {
  role   = "roles/container.admin"
  member = "serviceAccount:821879192255@cloudbuild.gserviceaccount.com"
}

# resource "google_storage_bucket_iam_binding" "cloudlab-vm" {
#   bucket = "cloud-lab"
#   role   = "roles/storage.objectViewer"

#   members = ["serviceAccount:${module.cos-vm.service_account}"]
# }


resource "google_service_account" "cert-manager" {
  account_id   = "cert-manager"
  display_name = "service account for cert-manager DNS management"
}
resource "google_project_iam_member" "cert-manager" {
  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.cert-manager.email}"
}
