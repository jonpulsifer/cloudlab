locals {
  iot_home_pulsifer_ca_cidr = "192.168.100.0/24"
  iot_home_pulsifer_ca_wlan = "Evilcorp IoT"
}

resource "unifi_network" "iot_home_pulsifer_ca" {
  name          = "iot.home.pulsifer.ca"
  domain_name   = "iot.home.pulsifer.ca"
  network_group = "LAN"
  purpose       = "corporate"
  subnet        = local.iot_home_pulsifer_ca_cidr
  vlan_id       = 100

  dhcp_enabled = true
  # dhcp_dns     = ["1.1.1.1", "1.0.0.1", "8.8.8.8", "8.8.4.4"]
  dhcp_lease = 86400
  dhcp_start = cidrhost(local.iot_home_pulsifer_ca_cidr, 100)
  dhcp_stop  = cidrhost(local.iot_home_pulsifer_ca_cidr, 150)
}

resource "unifi_wlan" "evilcorp_iot" {
  name       = local.iot_home_pulsifer_ca_wlan
  security   = "wpapsk"
  passphrase = data.vault_generic_secret.wifi.data[local.iot_home_pulsifer_ca_wlan]
  hide_ssid  = true

  ap_group_ids = [
    "5fa7dea43d5d281558ac3cc5" # data.unifi_ap_group.all_aps.id,
  ]

  network_id    = unifi_network.iot_home_pulsifer_ca.id
  user_group_id = unifi_user_group.iot.id

  multicast_enhance = true
}

resource "unifi_user" "home_iot" {
  for_each               = local.clients.home_iot
  name                   = each.key
  mac                    = each.value.mac
  blocked                = lookup(each.value, "blocked", false)
  note                   = lookup(each.value, "note", "Managed by terraform")
  allow_existing         = lookup(each.value, "allow_existing", true)
  skip_forget_on_destroy = lookup(each.value, "skip_forget_on_destroy", true)
  network_id             = unifi_network.iot_home_pulsifer_ca.id
  user_group_id          = unifi_user_group.iot.id
}
