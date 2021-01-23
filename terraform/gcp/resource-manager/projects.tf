module "jonpulsifer" {
  source          = "github.com/jonpulsifer/terraform-modules//gcp-project"
  project_id      = "jonpulsifer"
  folder_id       = google_folder.production.name
  billing_account = data.google_billing_account.cloudlab.id
  labels = {
    environment = "production"
  }
}

module "homelab-ng" {
  source          = "github.com/jonpulsifer/terraform-modules//gcp-project"
  project_id      = "homelab-ng"
  name            = "whats a home lab"
  folder_id       = google_folder.production.name
  billing_account = data.google_billing_account.cloudlab.id
  labels = {
    environment = "home"
  }
}

module "kubesec" {
  source          = "github.com/jonpulsifer/terraform-modules//gcp-project"
  project_id      = "kubesec"
  name            = "kubesec"
  folder_id       = google_folder.production.name
  compute         = true
  billing_account = data.google_billing_account.cloudlab.id
  labels = {
    environment = "production"
  }
}

module "secure-the-cloud" {
  source          = "github.com/jonpulsifer/terraform-modules//gcp-project"
  project_id      = "secure-the-cloud"
  name            = "secure teh cloud"
  folder_id       = google_folder.dev.name
  billing_account = data.google_billing_account.cloudlab.id
  labels = {
    environment = "production"
  }
}

module "cloud-glue" {
  source          = "github.com/jonpulsifer/terraform-modules//gcp-project"
  project_id      = "cloud-glue"
  name            = "cloud-glue"
  folder_id       = google_folder.production.name
  compute         = true
  billing_account = data.google_billing_account.cloudlab.id
  labels = {
    environment = "production"
  }
}
