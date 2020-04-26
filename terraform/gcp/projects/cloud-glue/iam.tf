resource "google_service_account" "sticky" {
  account_id   = "sticky"
  display_name = "the robot that holds the cloud together"
}

resource "google_pubsub_topic_iam_member" "domain" {
  project = local.project
  topic   = google_pubsub_topic.apps_script.name
  role    = "roles/pubsub.publisher"
  member  = "domain:pulsifer.ca"
}
