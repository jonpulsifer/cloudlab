resource "google_monitoring_alert_policy" "5xx-errors-wishlist" {
  display_name = "5xx Errors - Wishlist"
  enabled      = true
  combiner     = "OR"

  conditions = [
    {
      display_name = "external/prometheus/nginx_ingress_controller_requests for wishlist, 5\\d\\d [SUM]"

      condition_threshold {
        trigger = [
          {
            count = 1
          },
        ]

        filter     = "metric.type=\"external.googleapis.com/prometheus/nginx_ingress_controller_requests\" resource.type=\"k8s_container\" metric.label.\"ingress\"=\"wishlist\" metric.label.\"status\"=monitoring.regex.full_match(\"5\\\\d\\\\d\")"
        duration   = "0s"
        comparison = "COMPARISON_GT"

        aggregations = [
          {
            alignment_period     = "60s"
            cross_series_reducer = "REDUCE_SUM"
            per_series_aligner   = "ALIGN_DELTA"
          },
        ]
      }
    },
  ]

  notification_channels = ["projects/kubesec/notificationChannels/11994174365895596606"]
}
