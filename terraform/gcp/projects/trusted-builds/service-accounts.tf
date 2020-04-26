resource "google_service_account" "builder" {
  account_id   = "builder"
  display_name = "Builder VM service account"
}
