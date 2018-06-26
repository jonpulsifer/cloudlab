data "google_compute_image" "trusted-build" {
  family  = "ubuntu-1804-lts"
  project = "trusted-builds"
}

resource "google_compute_disk" "home-dir" {
  name = "home-dir"
  type = "pd-ssd"
  zone = "${var.gcp_config["zone"]}"
  size = "10"

  labels {
    environment = "dev"
  }
}

resource "google_compute_instance_template" "bullseye" {
  name_prefix = "bullseye"
  description = "This is the primary lab VM template"

  tags = ["ubuntu", "bullseye", "terraform", "packer"]

  labels = {
    environment = "dev"
  }

  instance_description = "[lab] packer built and terraform deployed"
  machine_type         = "n1-standard-1"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  // Create a new boot disk from an image
  disk {
    source_image = "${data.google_compute_image.trusted-build.self_link}"
    mode         = "READ_WRITE"
    auto_delete  = true
    boot         = true
    disk_type    = "pd-standard"
    disk_size_gb = 30
    type         = "PERSISTENT"
  }

  // Use an existing disk resource
  disk {
    source      = "home-dir"
    auto_delete = false
    boot        = false
  }

  network_interface {
    subnetwork = "vms"

    access_config = {
      # nat_ip = ""
      network_tier = "PREMIUM"
    }
  }

  metadata {
    foo = "bar"
  }

  service_account {
    email  = "bullseye@secure-the-cloud.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance_group_manager" "bullseye" {
  name               = "bullseye"
  instance_template  = "${google_compute_instance_template.bullseye.self_link}"
  base_instance_name = "bullseye"
  zone               = "${var.gcp_config["zone"]}"
  target_size        = "0"
  update_strategy    = "RESTART"
}
