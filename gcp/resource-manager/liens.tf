resource "google_resource_manager_lien" "cud" {
  parent       = "projects/${google_project.kubesec.id}"
  restrictions = ["resourcemanager.projects.delete"]
  origin       = "committed-use-discount-in-use"
  reason       = "committed use discount in use expiry: 9 Jul 2020"
}

resource "google_resource_manager_lien" "kubesec" {
  parent       = "projects/${google_project.kubesec.id}"
  restrictions = ["resourcemanager.projects.delete"]
  origin       = "production-environment"
  reason       = "Production Environment"
}

resource "google_resource_manager_lien" "jonpulsifer" {
  parent       = "projects/${google_project.jonpulsifer.id}"
  restrictions = ["resourcemanager.projects.delete"]
  origin       = "i-like-this-project-name"
  reason       = "it me"
}

resource "google_resource_manager_lien" "trusted-builds" {
  parent       = "projects/${google_project.trusted-builds.id}"
  restrictions = ["resourcemanager.projects.delete"]
  origin       = "production-environment"
  reason       = "Production Environment"
}

resource "google_resource_manager_lien" "secure-the-cloud" {
  parent       = "projects/${google_project.secure-the-cloud.id}"
  restrictions = ["resourcemanager.projects.delete"]
  origin       = "i-like-this-project-name"
  reason       = "vanity amirite"
}

