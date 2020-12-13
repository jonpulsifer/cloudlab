resource "google_cloudfunctions_function" "ddns" {
  name        = "ddns"
  description = "dynamic dns function thingy"
  runtime     = "go113"

  max_instances       = 10
  available_memory_mb = 128
  trigger_http        = true
  timeout             = 60
  entry_point         = "DDNSCloudEventReceiver"
  labels              = {}

  environment_variables = {
    DDNS_API_TOKEN = ""
  }

  lifecycle {
    ignore_changes = [environment_variables, labels]
  }
}
