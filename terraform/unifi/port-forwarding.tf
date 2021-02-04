resource "unifi_port_forward" "ingress_nginx" {
  name     = "HTTP(S) Nginx Ingress on the nuc"
  enabled  = true
  src_ip   = "any"
  dst_port = "80,443"
  protocol = "tcp"

  fwd_port = "80,443"
  fwd_ip   = cidrhost(local.homelab_ng_cidr, local.clients.homelab_ng.nuc.ip) 
}

resource "unifi_port_forward" "nuc_ssh" {
  name     = "SSH to nuc"
  enabled  = false
  src_ip   = "any"
  dst_port = "22"
  protocol = "tcp"

  fwd_port = "22"
  fwd_ip   = cidrhost(local.homelab_ng_cidr, local.clients.homelab_ng.nuc.ip) 
}
