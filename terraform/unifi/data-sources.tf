locals {
  clients = yamldecode(file("./clients.yml"))
}

data "vault_generic_secret" "wifi" {
  path = "home/wifi"
}

# these are broken rn
# data "unifi_ap_group" "all_aps" {
#   name = "All APs"
# }

# data "unifi_ap_group" "ice_shack" {
#   name = "Ice Shack Wifi"
# }
