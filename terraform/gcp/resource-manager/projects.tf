data "google_project" "kubesec" {
  project_id = "kubesec"
}

resource "google_project" "kubesec" {
  name            = "${data.google_project.kubesec.name}"
  project_id      = "${data.google_project.kubesec.id}"
  folder_id       = "${google_folder.production.name}"
  billing_account = "${data.google_billing_account.cloudlab.id}"
  skip_delete     = true
}

data "google_project" "trusted-builds" {
  project_id = "trusted-builds"
}

resource "google_project" "trusted-builds" {
  name            = "${data.google_project.trusted-builds.name}"
  project_id      = "${data.google_project.trusted-builds.id}"
  folder_id       = "${google_folder.production.name}"
  billing_account = "${data.google_billing_account.cloudlab.id}"
  skip_delete     = true
}

data "google_project" "secure-the-cloud" {
  project_id = "secure-the-cloud"
}

resource "google_project" "secure-the-cloud" {
  name        = "${data.google_project.secure-the-cloud.name}"
  project_id  = "${data.google_project.secure-the-cloud.id}"
  folder_id   = "${google_folder.dev.name}"
  skip_delete = true
}
