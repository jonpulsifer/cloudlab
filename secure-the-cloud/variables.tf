variable "gcp_config" {
  type = "map"

  default = {
    organization        = "5046617773"           # Organization
    folder              = "folders/55741234626"  # Active (billable)
    billing_account     = "009BE0-2F835F-F20651" # My VISA :(
    project_id          = "secure-the-cloud"     # project id
    project_number      = "594184039024"         # project number
    region              = "us-east4"             # north virginia
    zone                = "us-east4-b"           # gets k8s releases first
    auto_create_network = "false"                # disable automatic network creation
    node_cidr           = "10.13.37.0/28"        # cidr for the VMs
  }
}
