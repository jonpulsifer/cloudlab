resource "google_cloudfunctions_function" "cloud_glue" {
  name                  = "cloud-glue"
  description           = "the glue that holds the cloud together"
  runtime               = "go113"
  service_account_email = google_service_account.sticky.email

  available_memory_mb = 128
  trigger_http        = true
  timeout             = 60
  entry_point         = "AppScriptHandler"
  labels              = {}

  lifecycle {
    ignore_changes = [environment_variables, labels]
  }
}
