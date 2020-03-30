resource "google_service_account" "atlantis" {
  account_id   = "atlantis"
  display_name = "atlantis robot that runs terraform"
}
