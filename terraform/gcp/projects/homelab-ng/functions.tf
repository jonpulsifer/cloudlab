resource "google_cloudfunctions_function" "ddns" {
  name        = "ddns"
  description = "dynamic dns function thingy"
  runtime     = "go113"

  available_memory_mb = 128
  trigger_http        = true
  timeout             = 60
  entry_point         = "UpdateDDNS"
  labels              = {}

  environment_variables = {
    API_TOKEN = ""
  }

  lifecycle {
    ignore_changes = [environment_variables, labels]
  }
}
