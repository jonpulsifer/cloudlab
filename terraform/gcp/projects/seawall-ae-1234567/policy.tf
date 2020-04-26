resource "google_project_organization_policy" "bool-policies" {
  for_each = {
    "iam.disableServiceAccountCreation" : false,
    "iam.disableServiceAccountKeyCreation" : false,
    "compute.disableGuestAttributesAccess" : true,
    "compute.requireShieldedVm" : false,
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
    "iam.allowedPolicyMemberDomains", # allUsers and allAuthenticatedUsers breaks this
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
      "projects/gce-uefi-images",
      "projects/cos-cloud",
    ],
    "gcp.resourceLocations" : [
      #"in:northamerica-northeast1-locations",
      "in:northamerica-locations", # storage is global :( (gcr)
    ],
  }
  constraint = format("constraints/%s", each.key)
  list_policy {
    inherit_from_parent = true
    allow {
      values = each.value
    }
  }
}
