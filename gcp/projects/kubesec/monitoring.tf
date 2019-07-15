resource "google_monitoring_alert_policy" "stackdriver-free-storage-alert" {
  enabled      = true
  display_name = "Stackdriver ingested log volume over 50GiB (chargeable)"
  combiner     = "OR"

  notification_channels = [
    "projects/kubesec/notificationChannels/11994174365895596606",
  ]

  conditions {
    display_name = "Monthly log bytes ingested [SUM]"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/billing/monthly_bytes_ingested\" resource.type=\"global\""
      comparison      = "COMPARISON_GT"
      duration        = "1800s"
      threshold_value = "5E+10"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period     = "3600s"
        cross_series_reducer = "REDUCE_SUM"
        per_series_aligner   = "ALIGN_MAX"
      }
    }
  }
}

resource "google_monitoring_alert_policy" "stackdriver-free-storage-warning" {
  enabled      = true
  display_name = "Stackdriver ingested log volume over 25GiB (not chargeable)"
  combiner     = "OR"

  notification_channels = [
    "projects/kubesec/notificationChannels/11994174365895596606",
  ]

  conditions {
    display_name = "Monthly log bytes ingested [SUM]"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/billing/monthly_bytes_ingested\" resource.type=\"global\""
      comparison      = "COMPARISON_GT"
      duration        = "1800s"
      threshold_value = "25E+9"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period     = "3600s"
        cross_series_reducer = "REDUCE_SUM"
        per_series_aligner   = "ALIGN_MAX"
      }
    }
  }
}

