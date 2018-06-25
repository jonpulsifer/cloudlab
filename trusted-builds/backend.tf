terraform {
  backend "gcs" {
    bucket         = ""
    prefix         = "state"
    project        = "trusted-builds"
    encryption_key = ""
  }
}
