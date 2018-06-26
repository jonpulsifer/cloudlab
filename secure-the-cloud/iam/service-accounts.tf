resource "google_service_account" "vm" {
  account_id   = "bullseye"
  display_name = "VM service account"
}

output "vm_service_account" {
  value = "${google_service_account.vm.email}"
}
