resource "google_cloudbuild_trigger" "linux-build" {
  description = "Linux Build"

  trigger_template {
    repo_name   = "github_jonpulsifer_cloudlab-linux-build"
    branch_name = "master"
  }

  filename = "cloudbuild/docker.yaml"
}

resource "google_cloudbuild_trigger" "cloudlab-services" {
  description = "Deploy cloudlab services to GCS"

  trigger_template {
    repo_name   = "github-jonpulsifer-cloudlab"
    branch_name = "master"
  }

  filename = "cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "wishlist" {
  description = "Build and deploy the Wishlist app"

  trigger_template {
    repo_name   = "github_jonpulsifer_wishlist-rails"
    branch_name = "master"
  }

  filename = "cloudbuild.yaml"
}
