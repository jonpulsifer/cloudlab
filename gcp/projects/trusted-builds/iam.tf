resource "google_project_iam_policy" "explicit" {
  project     = data.google_project.trusted-builds.project_id
  policy_data = data.google_iam_policy.explicit.policy_data
}

data "google_iam_policy" "explicit" {
  binding {
    members = [format("serviceAccount:%s@cloudbuild.gserviceaccount.com", data.google_project.trusted-builds.number)]
    role    = "roles/cloudbuild.builds.builder"
  }

  binding {
    members = [format("serviceAccount:%s@cloudbuild.gserviceaccount.com", data.google_project.trusted-builds.number)]
    role    = "roles/compute.instanceAdmin"
  }

  binding {
    members = [format("serviceAccount:service-%s@compute-system.iam.gserviceaccount.com", data.google_project.trusted-builds.number)]
    role    = "roles/compute.serviceAgent"
  }

  binding {
    members = [format("serviceAccount:%s@cloudbuild.gserviceaccount.com", data.google_project.trusted-builds.number)]
    role    = "roles/compute.storageAdmin"
  }

  binding {
    members = [format("serviceAccount:service-%s@container-engine-robot.iam.gserviceaccount.com", data.google_project.trusted-builds.number)]
    role    = "roles/container.serviceAgent"
  }

  binding {
    members = [
      format("serviceAccount:%s-compute@developer.gserviceaccount.com", data.google_project.trusted-builds.number),
      format("serviceAccount:%s@cloudservices.gserviceaccount.com", data.google_project.trusted-builds.number),
      format("serviceAccount:service-%s@containerregistry.iam.gserviceaccount.com", data.google_project.trusted-builds.number),
      format("serviceAccount:%s@appspot.gserviceaccount.com", data.google_project.trusted-builds.project_id)
    ]

    role = "roles/editor"
  }

  binding {
    members = [format("serviceAccount:service-%s@cloud-filer.iam.gserviceaccount.com", data.google_project.trusted-builds.number)]
    role    = "roles/file.serviceAgent"
  }

  binding {
    members = [format("serviceAccount:service-%s@sourcerepo-service-accounts.iam.gserviceaccount.com", data.google_project.trusted-builds.number)]
    role    = "roles/sourcerepo.serviceAgent"
  }

  binding {
    members = [
      "serviceAccount:gke-nodes-lab@kubesec.iam.gserviceaccount.com",
    ]
    role = "roles/storage.objectViewer"
  }
}
