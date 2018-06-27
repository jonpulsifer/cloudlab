resource "google_project_iam_member" "compute-default" {
  role   = "roles/editor"
  member = "serviceAccount:${module.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "compute-system" {
  role   = "roles/compute.serviceAgent"
  member = "serviceAccount:service-${module.project.number}@compute-system.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudservices" {
  role   = "roles/editor"
  member = "serviceAccount:${module.project.number}@cloudservices.gserviceaccount.com"
}

resource "google_project_iam_member" "container-registry" {
  role   = "roles/editor"
  member = "serviceAccount:service-${module.project.number}@containerregistry.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "container-analysis" {
  role   = "roles/containeranalysis.ServiceAgent"
  member = "serviceAccount:service-${module.project.number}@container-analysis.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "source-repo" {
  role   = "roles/sourcerepo.serviceAgent"
  member = "serviceAccount:service-${module.project.number}@sourcerepo-service-accounts.iam.gserviceaccount.com"
}

# cloudservices for the igms in secure-the-cloud
resource "google_project_iam_member" "image-user" {
  role   = "roles/compute.imageUser"
  member = "serviceAccount:594184039024@cloudservices.gserviceaccount.com"
}
