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
  member = "serviceAccount:667960578724@cloudservices.gserviceaccount.com"
}

# In this lab your GKE nodes will need to access GCR for their storage
# so we give them roles/storage.objectViewer on the entire project because
# reasons
resource "google_project_iam_member" "gcr-for-cloudlab-gke-nodes" {
  project = "trusted-builds"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:gke-nodes-cloudlab@kubesec.iam.gserviceaccount.com"
}
