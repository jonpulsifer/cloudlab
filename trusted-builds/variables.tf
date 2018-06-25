variable "gcp_config" {
  type = "map"

  default = {
    billing_account     = "009BE0-2F835F-F20651"      # My VISA :(
    organization        = "5046617773"                # Organization
    folder              = "folders/55741234626"       # Active (billable)
    project             = "trusted-builds"            # derp
    region              = "northamerica-northeast1"   # north virginia
    zone                = "northamerica-northeast1-a" # gets k8s releases first
    auto_create_network = "false"                     # disable automatic network creation
    node_cidr           = "10.20.30.0/28"             # cidr for the VMs
  }
}
