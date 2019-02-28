locals {
  pubsub_project = "kubesec"
  sink_name      = "firehose"
}

resource "google_logging_folder_sink" "production-firehose" {
  name             = "${local.sink_name}"
  folder           = "${google_folder.production.name}"
  include_children = true

  destination = "pubsub.googleapis.com/projects/${local.pubsub_project}/topics/${local.sink_name}"

  filter = "protoPayload.serviceName=(\"cloudresourcemanager.googleapis.com\" OR \"cloudkms.googleapis.com\" OR \"iam.googleapis.com\") AND protoPayload.methodName:(\"Create\" OR \"Update\" OR \"Delete\")"
}

resource "google_pubsub_topic_iam_member" "production-firehose" {
  topic  = "${local.sink_name}"
  role   = "roles/pubsub.publisher"
  member = "${google_logging_folder_sink.production-firehose.writer_identity}"
}

resource "google_logging_folder_sink" "dev-firehose" {
  name             = "dev-${local.sink_name}"
  folder           = "${google_folder.dev.name}"
  include_children = true

  destination = "pubsub.googleapis.com/projects/${local.pubsub_project}/topics/${local.sink_name}"

  filter = "protoPayload.serviceName=(\"cloudresourcemanager.googleapis.com\" OR \"cloudkms.googleapis.com\" OR \"iam.googleapis.com\") AND protoPayload.methodName:(\"Create\" OR \"Update\" OR \"Delete\")"
}

resource "google_pubsub_topic_iam_member" "dev-firehose" {
  topic  = "${local.sink_name}"
  role   = "roles/pubsub.publisher"
  member = "${google_logging_folder_sink.dev-firehose.writer_identity}"
}
