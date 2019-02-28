locals {
  sink_bucket = "cloud-lab"
}

resource "google_logging_organization_sink" "firehose" {
  name             = "firehose"
  org_id           = "${data.google_organization.org.id}"
  include_children = true

  destination = "storage.googleapis.com/${local.sink_bucket}"

  #  filter = ""
}

resource "google_project_iam_binding" "log-writer" {
  role = "roles/storage.objectCreator"

  members = [
    "${google_logging_organization_sink.firehose.writer_identity}",
  ]
}
