resource "google_project" "kubesec" {
  name                = "kubesec - cloudlab"
  project_id          = "kubesec"
  folder_id           = google_folder.production.name
  billing_account     = data.google_billing_account.cloudlab.id
  skip_delete         = true
  auto_create_network = false

  labels = {
    environment = "production"
  }
}

resource "google_compute_project_metadata_item" "oslogin_kubesec" {
  project = google_project.kubesec.id
  key     = "enable-oslogin"
  value   = "TRUE"
}

resource "google_compute_project_metadata_item" "oslogin_2fa_kubesec" {
  project = google_project.kubesec.id
  key     = "enable-oslogin-2fa"
  value   = "TRUE"
}

resource "google_compute_project_metadata_item" "guest_attributes_kubesec" {
  project = google_project.kubesec.id
  key     = "enable-guest-attributes"
  value   = "TRUE"
}

resource "google_compute_project_metadata_item" "os_inventory_kubesec" {
  project = google_project.kubesec.id
  key     = "enable-os-inventory"
  value   = "TRUE"
}

resource "google_project" "trusted-builds" {
  name                = "trusted builds"
  project_id          = "trusted-builds"
  folder_id           = google_folder.production.name
  billing_account     = data.google_billing_account.cloudlab.id
  skip_delete         = true
  auto_create_network = false

  labels = {
    environment = "production"
  }
}

resource "google_compute_project_metadata_item" "oslogin_trusted-builds" {
  project = google_project.trusted-builds.id
  key     = "enable-oslogin"
  value   = "TRUE"
}

resource "google_compute_project_metadata_item" "oslogin_2fa_trusted-builds" {
  project = google_project.trusted-builds.id
  key     = "enable-oslogin-2fa"
  value   = "TRUE"
}

resource "google_compute_project_metadata_item" "guest_attributes_trusted-builds" {
  project = google_project.trusted-builds.id
  key     = "enable-guest-attributes"
  value   = "TRUE"
}


resource "google_compute_project_metadata_item" "os_inventory_trusted-builds" {
  project = google_project.trusted-builds.id
  key     = "enable-os-inventory"
  value   = "TRUE"
}

resource "google_project" "secure-the-cloud" {
  name                = "secure the cloud"
  project_id          = "secure-the-cloud"
  folder_id           = google_folder.dev.name
  skip_delete         = true
  auto_create_network = false

  labels = {
    environment = "dev"
  }
}

resource "google_project" "jonpulsifer" {
  name                = "jonpulsifer"
  project_id          = "jonpulsifer"
  folder_id           = google_folder.production.name
  billing_account     = data.google_billing_account.cloudlab.id
  skip_delete         = true
  auto_create_network = false

  labels = {
    environment = "production"
  }
}

resource "google_project" "homelab-ng" {
  name                = "homelab-ng"
  project_id          = "homelab-ng"
  folder_id           = google_folder.production.name
  billing_account     = data.google_billing_account.cloudlab.id
  skip_delete         = true
  auto_create_network = false

  labels = {
    environment = "home"
  }
}
