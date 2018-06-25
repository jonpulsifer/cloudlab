resource "google_cloudbuild_trigger" "linux-build-gce" {
  description = "GCE Linux Build"

  trigger_template {
    project     = "trusted-builds"
    repo_name   = "github-j0npulsifer-cloudlab-linux-build"
    branch_name = ".*"
  }

  filename = "cloudbuild-gce.yaml"
}

resource "google_cloudbuild_trigger" "linux-build-docker" {
  description = "Docker Linux Build"

  trigger_template {
    project     = "trusted-builds"
    repo_name   = "github-j0npulsifer-cloudlab-linux-build"
    branch_name = ".*"
  }

  filename = "cloudbuild-docker.yaml"
}
