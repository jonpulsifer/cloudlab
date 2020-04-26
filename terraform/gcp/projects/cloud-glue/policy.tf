resource "google_project_organization_policy" "list-policies-allow" {
  project = local.project
  for_each = toset([
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

resource "google_project_organization_policy" "bool-policies" {
  for_each = {
    "iam.disableServiceAccountCreation" : false,
    #"iam.disableServiceAccountKeyCreation" : false,
    #"compute.disableGuestAttributesAccess" : true,
    #"compute.requireShieldedVm" : false,
  }
  project    = local.project
  constraint = format("constraints/%s", each.key)
  boolean_policy {
    enforced = each.value
  }
}
