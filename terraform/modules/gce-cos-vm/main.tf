data "google_compute_image" "trusted-image" {
  family  = "${var.image_config["family"]}"
  project = "${var.image_config["project"]}"
}

resource "google_compute_disk" "pd-ssd" {
  name = "${var.name}-ssd"
  type = "pd-ssd"
  size = "${var.instance_config["ssd_size"]}"
}

resource "google_compute_address" "vm-with-ssd" {
  name         = "${var.name}"
  address_type = "EXTERNAL"
}

resource "google_compute_instance_template" "vm-with-ssd" {
  name_prefix = "${var.name}"
  description = "GCE COS template with PD-SSD"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    "google_compute_disk.pd-ssd",
  ]

  tags = ["${var.image_config["family"]}", "vm", "terraform", "packer"]

  instance_description = "[lab] packer built and terraform deployed"
  machine_type         = "${var.instance_config["machine_type"]}"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = "${var.instance_config["preemptible"]}"
  }

  // Create a new boot disk from an image
  disk {
    source_image = "${data.google_compute_image.trusted-image.self_link}"
    mode         = "READ_WRITE"
    auto_delete  = true
    boot         = true
    disk_type    = "pd-standard"
    disk_size_gb = 24
    type         = "PERSISTENT"
  }

  // Use an existing disk resource
  disk {
    source      = "${google_compute_disk.pd-ssd.name}"
    mode        = "READ_WRITE"
    auto_delete = false
    boot        = false
  }

  network_interface {
    subnetwork = "${var.instance_config["subnet"]}"

    access_config = {
      nat_ip       = "${google_compute_address.vm-with-ssd.address}"
      network_tier = "PREMIUM"
    }
  }

  metadata {
    "user-data" = "${var.instance_config["cloud_init"]}"
  }

  service_account {
    email  = "${google_service_account.vm.email}"
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance_group_manager" "vm" {
  count = "${var.instance_config["online"] ? 1 : 0 }"
  name  = "${var.name}-igm"

  depends_on = [
    "google_compute_instance_template.vm-with-ssd",
  ]

  instance_template  = "${google_compute_instance_template.vm-with-ssd.self_link}"
  base_instance_name = "${var.name}"
  target_size        = "1"
  update_strategy    = "RESTART"
}
