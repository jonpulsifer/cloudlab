resource "unifi_network" "home_pulsifer_ca" {
  name          = "home.pulsifer.ca"
  domain_name   = "home.pulsifer.ca"
  network_group = "LAN"
  purpose       = "corporate"
  subnet        = "192.168.1.0/24"

  dhcp_enabled = true
  dhcp_lease   = 86400
  dhcp_start   = "192.168.1.6"
  dhcp_stop    = "192.168.1.254"
}

resource "unifi_network" "homelab_ng" {
  name          = "homelab-ng"
  domain_name   = "home.pulsifer.ca"
  network_group = "LAN"
  purpose       = "corporate"
  subnet        = "10.0.0.0/24"
  vlan_id       = 1337

  dhcp_enabled = true
  dhcp_lease   = 14400
  dhcp_start   = "10.0.0.200"
  dhcp_stop    = "10.0.0.254"
}

resource "unifi_network" "iot_home_pulsifer_ca" {
  name          = "iot.home.pulsifer.ca"
  domain_name   = "iot.home.pulsifer.ca"
  network_group = "LAN"
  purpose       = "corporate"
  subnet        = "192.168.100.0/24"
  vlan_id       = 100

  dhcp_enabled = true
  dhcp_dns     = ["1.1.1.1", "1.0.0.1", "8.8.8.8", "8.8.4.4"]
  dhcp_lease   = 60
  dhcp_start   = "192.168.100.100"
  dhcp_stop    = "192.168.100.150"
}
