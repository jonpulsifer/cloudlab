resource "google_service_account" "vm" {
  account_id   = "bullseye"
  display_name = "VM service account for foo"
}

output "service_account" {
  value = "${google_service_account.vm.email}"
}
