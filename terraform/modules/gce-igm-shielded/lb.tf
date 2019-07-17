resource "google_compute_target_pool" "lb" {
  count = var.enable_lb ? 1 : 0
  name  = join("-", [var.name, "pool"])
}

resource "google_compute_forwarding_rule" "lb" {
  count       = var.enable_lb ? 1 : 0
  name        = join("-", ["lb", var.name])
  target      = google_compute_target_pool.lb[count.index].self_link
  port_range  = var.port_range
  ip_protocol = var.protocol
}
