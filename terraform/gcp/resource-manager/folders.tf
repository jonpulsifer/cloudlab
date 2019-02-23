resource "google_folder" "production" {
  display_name = "Production - Billable"
  parent       = "${data.google_organization.org.name}"
}

resource "google_folder" "dev" {
  display_name = "Dev - Not Billable"
  parent       = "${data.google_organization.org.name}"
}
