generate "provider" {
  path      = "provider_gcp_project.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project = "${local.project_settings.project_id}"
  region  = "${local.project_settings.region}"
}
EOF
}

locals {
  project_settings = read_terragrunt_config(find_in_parent_folders("_configuration/project.hcl")).inputs
}
