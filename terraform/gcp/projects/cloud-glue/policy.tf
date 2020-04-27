resource "google_project_organization_policy" "list-policies-allow" {
  project = local.project
  for_each = toset([
    "serviceuser.services",
    "iam.allowedPolicyMemberDomains", # so anyone can make an HTTP request to the function
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
    "compute.disableGuestAttributesAccess" : true,
    "compute.requireShieldedVm" : false,
  }
  project    = local.project
  constraint = format("constraints/%s", each.key)
  boolean_policy {
    enforced = each.value
  }
}

# we can't deploy functions in canada yet :(
resource "google_project_organization_policy" "list-policies-values" {
  project = local.project
  for_each = {
    "compute.trustedImageProjects" : [
      "projects/dataflow-service-producer-prod",
    ],
    "gcp.resourceLocations" : [
      "in:us-east4-locations",
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
