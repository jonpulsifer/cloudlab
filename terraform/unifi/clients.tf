locals {
  clients = yamldecode(file("./clients.yml"))
}

resource "unifi_user" "phones" {
  for_each               = local.clients.phones
  name                   = each.key
  mac                    = each.value.mac
  blocked                = lookup(each.value, "blocked", false)
  note                   = lookup(each.value, "note", "Managed by terraform")
  allow_existing         = lookup(each.value, "allow_existing", true)
  skip_forget_on_destroy = lookup(each.value, "skip_forget_on_destroy", true)
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
