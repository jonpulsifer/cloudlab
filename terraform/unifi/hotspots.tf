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
