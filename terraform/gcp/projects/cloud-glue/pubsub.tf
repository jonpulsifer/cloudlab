resource "google_pubsub_topic" "apps_script" {
  name = "gas"

  labels = {
    env = "production"
  }
}

resource "google_pubsub_subscription" "apps_script" {
  name  = "gas"
  topic = google_pubsub_topic.apps_script.name

  labels = {
    env = "production"
  }
  message_retention_duration = "3600s"
  retain_acked_messages      = true
}
