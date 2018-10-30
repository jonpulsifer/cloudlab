resource "google_cloudbuild_trigger" "linux-build-docker" {
  description = "Docker Linux Build"

  trigger_template {
    project     = "trusted-builds"
    repo_name   = "github_jonpulsifer_cloudlab-linux-build"
    branch_name = "master"
  }

  filename = "cloudbuild-docker.yaml"
}

resource "google_cloudbuild_trigger" "cloudlab-services" {
  description = "Deploy cloudlab services to GCS"

  trigger_template {
    project     = "trusted-builds"
    repo_name   = "github_jonpulsifer_cloudlab"
    branch_name = "master"
  }

  filename = "cloudbuild.yaml"
}
