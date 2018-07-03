resource "google_project_services" "apis" {
  services = [
    "clouddebugger.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudtrace.googleapis.com",
    "compute.googleapis.com",
    "dns.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "oslogin.googleapis.com",
    "pubsub.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "sourcerepo.googleapis.com",
    "stackdriver.googleapis.com",
    "stackdriverprovisioning.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",

    /* already taken care of */
    "bigquery-json.googleapis.com",

    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "deploymentmanager.googleapis.com",
    "replicapool.googleapis.com",
    "replicapoolupdater.googleapis.com",
    "resourceviews.googleapis.com",
  ]
}
