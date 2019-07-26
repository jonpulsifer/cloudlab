resource "google_binary_authorization_policy" "default" {
  provider = google-beta

  admission_whitelist_patterns {
    name_pattern = "gcr.io/kubesec/*"
  }

  admission_whitelist_patterns {
    name_pattern = "gcr.io/trusted-builds/*"
  }

  cluster_admission_rules {
    cluster                 = join(".", [data.google_client_config.current.zone, module.corp.name])
    enforcement_mode        = "DRYRUN_AUDIT_LOG_ONLY" # "ENFORCED_BLOCK_AND_AUDIT_LOG"
    evaluation_mode         = "REQUIRE_ATTESTATION"
    require_attestations_by = ["projects/kubesec/attestors/yolo"]
  }

  default_admission_rule {
    evaluation_mode  = "ALWAYS_DENY"
    enforcement_mode = "DRYRUN_AUDIT_LOG_ONLY"
  }
}
