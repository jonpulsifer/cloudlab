resource "google_organization_iam_member" "cscc-firehose" {
  org_id = "${data.google_organization.org.id}"
  role   = "roles/securitycenter.sourcesEditor"
  member = "serviceAccount:cscc-firehose@kubesec.iam.gserviceaccount.com"
}
