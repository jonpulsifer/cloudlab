locals {
  homelab_ng_cidr = "10.0.0.0/24"
  homelab_ng_wlan = "Evilcorp Labs"
}

resource "unifi_network" "homelab_ng" {
  name          = "homelab-ng"
  domain_name   = "home.pulsifer.ca"
  network_group = "LAN"
  purpose       = "corporate"
  subnet        = local.homelab_ng_cidr
  vlan_id       = 1337

  dhcp_enabled = true
  dhcp_lease   = 14400
  dhcp_start   = cidrhost(local.homelab_ng_cidr, 200)
  dhcp_stop    = cidrhost(local.homelab_ng_cidr, 254)
}

resource "unifi_wlan" "evilcorp_labs" {
  name       = local.homelab_ng_wlan
  security   = "wpapsk"
  passphrase = data.vault_generic_secret.wifi.data[local.homelab_ng_wlan]
  hide_ssid  = true

  ap_group_ids = [
    "5fa7dea43d5d281558ac3cc5" # data.unifi_ap_group.all_aps.id,
  ]

  network_id    = unifi_network.homelab_ng.id
  user_group_id = unifi_user_group.unmetered.id

  multicast_enhance = true
}

resource "unifi_user" "homelab_ng" {
  for_each               = merge(local.clients.lab, local.clients.rpis)
  name                   = each.key
  mac                    = each.value.mac
  fixed_ip               = lookup(each.value, "ip", false) == false ? null : cidrhost(local.homelab_ng_cidr, each.value.ip)
  blocked                = lookup(each.value, "blocked", false)
  note                   = lookup(each.value, "note", "Managed by terraform")
  allow_existing         = lookup(each.value, "allow_existing", true)
  skip_forget_on_destroy = lookup(each.value, "skip_forget_on_destroy", true)
  network_id             = unifi_network.homelab_ng.id
  user_group_id          = unifi_user_group.unmetered.id
}
