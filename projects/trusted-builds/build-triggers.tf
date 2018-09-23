resource "google_cloudbuild_trigger" "linux-build-gce" {
  description = "GCE Linux Build"

  trigger_template {
    project     = "trusted-builds"
    repo_name   = "github_jonpulsifer_cloudlab-linux-build"
    branch_name = "master"
  }

  filename = "cloudbuild-gce.yaml"
}

resource "google_cloudbuild_trigger" "linux-build-docker" {
  description = "Docker Linux Build"

  trigger_template {
    project     = "trusted-builds"
    repo_name   = "github_jonpulsifer_cloudlab-linux-build"
    branch_name = "master"
  }

  filename = "cloudbuild-docker.yaml"
}
