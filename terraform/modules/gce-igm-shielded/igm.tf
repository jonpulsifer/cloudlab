data "google_compute_image" "trusted-image" {
  family  = var.image_family
  project = var.image_project
}

resource "google_compute_instance_template" "shielded_vm" {
  provider = "google-beta"

  depends_on = [
    "google_kms_crypto_key.igm",
  ]

  name_prefix = var.name
  description = "GCE Shielded VM Instance Template [terraform]"

  lifecycle {
    create_before_destroy = true
  }

  tags = [var.image_family, "vm", "terraform", "shielded", "managed", "encrypted"]

  instance_description = "Shielded VM with Encrypted Boot Disk"
  machine_type         = var.machine_type
  can_ip_forward       = false

  scheduling {
    automatic_restart   = var.preemptible ? false : true
    on_host_maintenance = var.preemptible ? "TERMINATE" : "MIGRATE"
    preemptible         = var.preemptible
  }

  // Create a new encrypted boot disk from an image
  disk {
    auto_delete = true
    boot        = true
    device_name = "encrypted-boot"
    disk_encryption_key {
      kms_key_self_link = google_kms_crypto_key.igm.self_link
    }


    source_image = data.google_compute_image.trusted-image.self_link
    disk_type    = "pd-standard"
    disk_size_gb = 24
    type         = "PERSISTENT"
  }

  // enable shielded vm
  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  network_interface {
    subnetwork = var.subnet

    #access_config {
    #  network_tier = "STANDARD"
    #}
  }

  metadata = {
    user-data                = var.cloud_init
    disable-legacy-endpoints = "TRUE"
    enable-oslogin           = "TRUE"
    enable-oslogin-2fa       = "TRUE"
  }

  service_account {
    email  = google_service_account.igm.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance_group_manager" "igm" {
  name = "${var.name}-igm"

  depends_on = [
    "google_compute_instance_template.shielded_vm",
  ]

  instance_template  = google_compute_instance_template.shielded_vm.self_link
  base_instance_name = var.name
  target_size        = var.target_size
  target_pools       = var.enable_lb ? google_compute_target_pool.lb[*].self_link : []
  update_strategy    = "RESTART"
}
