locals {
  home_pulsifer_ca_cidr = "192.168.1.0/24"
}

resource "unifi_network" "home_pulsifer_ca" {
  name          = "home.pulsifer.ca"
  domain_name   = "home.pulsifer.ca"
  network_group = "LAN"
  purpose       = "corporate"
  subnet        = local.home_pulsifer_ca_cidr

  dhcp_enabled = true
  dhcp_lease   = 86400
  dhcp_start   = cidrhost(local.home_pulsifer_ca_cidr, 6)
  dhcp_stop    = cidrhost(local.home_pulsifer_ca_cidr, 254)
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

resource "unifi_user" "phones" {
  for_each               = local.clients.phones
  name                   = each.key
  mac                    = each.value.mac
  blocked                = lookup(each.value, "blocked", false)
  note                   = lookup(each.value, "note", "Managed by terraform")
  allow_existing         = lookup(each.value, "allow_existing", true)
  skip_forget_on_destroy = lookup(each.value, "skip_forget_on_destroy", true)
  network_id             = unifi_network.home_pulsifer_ca.id
  user_group_id          = unifi_user_group.unmetered.id
}

resource "unifi_user" "computers" {
  for_each               = merge(local.clients.desktops, local.clients.laptops)
  name                   = each.key
  mac                    = each.value.mac
  blocked                = lookup(each.value, "blocked", false)
  note                   = lookup(each.value, "note", "Managed by terraform")
  allow_existing         = lookup(each.value, "allow_existing", true)
  skip_forget_on_destroy = lookup(each.value, "skip_forget_on_destroy", true)
  network_id             = unifi_network.home_pulsifer_ca.id
  user_group_id          = unifi_user_group.unmetered.id
}
