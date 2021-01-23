# terraform import unifi_network.home_pulsifer_ca 5eac9de4297bae02cc33e2b7
# once https://github.com/paultyng/go-unifi/issues/20 is fixed
resource "unifi_network" "home_pulsifer_ca" {
  name = "home.pulsifer.ca"
}
