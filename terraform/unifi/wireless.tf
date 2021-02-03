# data "unifi_ap_group" "all_aps" {
#   name = "All APs"
# }

# data "unifi_ap_group" "ice_shack" {
#   name = "Ice Shack Wifi"
# }


data "vault_generic_secret" "wifi" {
  path = "home/wifi"
}

resource "unifi_wlan" "evilcorp" {
  name       = "Evilcorp 3.0"
  security   = "wpapsk"
  passphrase = data.vault_generic_secret.wifi.data["Evilcorp 3.0"]

  ap_group_ids = [
    "5fa7dea43d5d281558ac3cc5" # data.unifi_ap_group.all_aps.id,
  ]

  network_id    = unifi_network.home_pulsifer_ca.id
  user_group_id = unifi_user_group.unmetered.id

  multicast_enhance = true
}

resource "unifi_wlan" "evilcorp_iot" {
  name       = "Evilcorp IoT"
  security   = "wpapsk"
  passphrase = data.vault_generic_secret.wifi.data["Evilcorp IoT"]
  hide_ssid  = true

  ap_group_ids = [
    "5fa7dea43d5d281558ac3cc5" # data.unifi_ap_group.all_aps.id,
  ]

  network_id    = unifi_network.iot_home_pulsifer_ca.id
  user_group_id = unifi_user_group.iot.id

  multicast_enhance = true
}

resource "unifi_wlan" "ice_shack_wifi" {
  name      = "Ice Shack WiFi"
  security  = "open"
  hide_ssid = false
  is_guest  = true

  ap_group_ids = [
    "5fbeb6701df29a12967f5b19" # data.unifi_ap_group.ice_shack.id,
  ]

  user_group_id = unifi_user_group.default.id
}
