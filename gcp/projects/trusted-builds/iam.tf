resource "google_project_iam_policy" "explicit" {
  project     = data.google_client_config.current.project
  policy_data = data.google_iam_policy.explicit.policy_data
}

data "google_iam_policy" "explicit" {
  binding {
    members = ["serviceAccount:attestor@${data.google_project.trusted-builds.id}.iam.gserviceaccount.com"]
    role    = "roles/binaryauthorization.attestorsAdmin"
  }

  binding {
    members = [
      "serviceAccount:service-${data.google_project.trusted-builds.number}@gcp-sa-binaryauthorization.iam.gserviceaccount.com",
    ]

    role = "roles/binaryauthorization.serviceAgent"
  }

  binding {
    members = ["serviceAccount:${data.google_project.trusted-builds.number}@cloudbuild.gserviceaccount.com"]
    role    = "roles/cloudbuild.builds.builder"
  }

  binding {
    members = ["serviceAccount:${data.google_project.trusted-builds.number}@cloudbuild.gserviceaccount.com"]
    role    = "roles/compute.instanceAdmin"
  }

  binding {
    members = ["serviceAccount:service-${data.google_project.trusted-builds.number}@compute-system.iam.gserviceaccount.com"]
    role    = "roles/compute.serviceAgent"
  }

  binding {
    members = ["serviceAccount:${data.google_project.trusted-builds.number}@cloudbuild.gserviceaccount.com"]
    role    = "roles/compute.storageAdmin"
  }

  binding {
    members = ["serviceAccount:service-${data.google_project.trusted-builds.number}@container-engine-robot.iam.gserviceaccount.com"]
    role    = "roles/container.serviceAgent"
  }

  binding {
    members = ["serviceAccount:attestor@${data.google_project.trusted-builds.id}.iam.gserviceaccount.com"]
    role    = "roles/containeranalysis.admin"
  }

  binding {
    members = ["serviceAccount:service-${data.google_project.trusted-builds.number}@gcp-sa-containerscanning.iam.gserviceaccount.com"]
    role    = "roles/containerscanning.ServiceAgent"
  }

  binding {
    members = ["serviceAccount:service-${data.google_project.trusted-builds.number}@container-analysis.iam.gserviceaccount.com"]
    role    = "roles/containeranalysis.ServiceAgent"
  }

  binding {
    members = [
      "serviceAccount:${data.google_project.trusted-builds.number}-compute@developer.gserviceaccount.com",
      "serviceAccount:${data.google_project.trusted-builds.number}@cloudservices.gserviceaccount.com",
      "serviceAccount:service-${data.google_project.trusted-builds.number}@containerregistry.iam.gserviceaccount.com",
      "serviceAccount:${data.google_project.trusted-builds.id}@appspot.gserviceaccount.com",
    ]

    role = "roles/editor"
  }

  binding {
    members = ["serviceAccount:service-${data.google_project.trusted-builds.number}@cloud-filer.iam.gserviceaccount.com"]
    role    = "roles/file.serviceAgent"
  }

  binding {
    members = ["serviceAccount:service-${data.google_project.trusted-builds.number}@sourcerepo-service-accounts.iam.gserviceaccount.com"]
    role    = "roles/sourcerepo.serviceAgent"
  }

  binding {
    members = [
      "serviceAccount:gke-nodes-lab@kubesec.iam.gserviceaccount.com",
    ]
    role = "roles/storage.objectViewer"
  }
}
