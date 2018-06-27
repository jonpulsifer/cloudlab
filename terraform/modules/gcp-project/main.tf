resource "google_project" "project" {
  name                = "${var.name}"
  billing_account     = "${var.billing_account}"
  project_id          = "${var.project_id}"
  folder_id           = "${var.folder_id}"
  org_id              = "${var.org_id}"
  auto_create_network = "${var.auto_create_network}"
  skip_delete         = "${var.skip_delete}"
}

data "google_project" "project" {
  project_id = "${google_project.project.project_id}"
}

output "id" {
  value = "${data.google_project.project.project_id}"
}

output "number" {
  value = "${data.google_project.project.number}"
}
