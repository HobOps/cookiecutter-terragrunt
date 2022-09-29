generate "provider" {
  path      = "provider_gcp_organization.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project = "${local.org_settings.org_backend_project}"
  region  = "${local.org_settings.org_backend_region}"
}
EOF
}

locals {
  org_settings     = read_terragrunt_config(find_in_parent_folders("org_settings.hcl")).inputs
  project_settings = read_terragrunt_config(find_in_parent_folders("_configuration/project.hcl")).inputs
}
