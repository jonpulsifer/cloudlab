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
