resource "google_project_organization_policy" "bool-policies" {
  for_each = {
    "iam.disableServiceAccountCreation" : false,
    "iam.disableServiceAccountKeyCreation" : false,
    "compute.disableGuestAttributesAccess" : false,
  }
  project    = local.project
  constraint = format("constraints/%s", each.key)
  boolean_policy {
    enforced = each.value
  }
}

resource "google_project_organization_policy" "list-policies-allow" {
  project = local.project
  for_each = toset([
    "iam.allowedPolicyMemberDomains", # workload identity requires this to be a thing :(
    "compute.vmExternalIpAccess",
    "serviceuser.services"
  ])
  constraint = format("constraints/%s", each.value)

  list_policy {
    inherit_from_parent = false
    allow {
      all = true
    }
  }
}

resource "google_project_organization_policy" "list-policies-values" {
  project = local.project
  for_each = {
    "compute.trustedImageProjects" : [
      "projects/cos-cloud",
      "projects/gke-node-images",
      "projects/ubuntu-os-cloud",
      "projects/ubuntu-os-gke-cloud"
    ],
    "gcp.resourceLocations" : [
      "us-east4-b",
      "us-east4"
    ],
  }
  constraint = format("constraints/%s", each.key)
  list_policy {
    inherit_from_parent = false
    allow {
      values = each.value
    }
  }
}
