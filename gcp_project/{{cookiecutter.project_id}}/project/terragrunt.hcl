# Common code used by group
include "remote_state_organization" {
  path           = find_in_parent_folders("_includes/remote_state_organization.hcl")
  merge_strategy = "deep"
}

include "provider_gcp_organization" {
  path           = find_in_parent_folders("_includes/provider_gcp_organization.hcl")
  merge_strategy = "deep"
}

# Code used by module
terraform {
  source = "{{cookiecutter.__terraform_module_google_factory_version}}"
}

locals {
  current_module   = basename(get_terragrunt_dir())
  org_settings     = read_terragrunt_config(find_in_parent_folders("org_settings.hcl")).inputs
  project_settings = read_terragrunt_config(find_in_parent_folders("_configuration/${local.current_module}.hcl")).inputs
}

inputs = merge(
  local.org_settings,
  local.project_settings,
  {
    name                 = local.project_settings.project_id
    activate_apis        = concat(local.project_settings.activate_apis, local.org_settings.org_activate_apis)
    bucket_project       = local.org_settings.org_backend_project
    bucket_name          = lookup(local.project_settings, "bucket_name", "${local.project_settings.project_id}-tfstate")
    bucket_force_destroy = lookup(local.project_settings, "bucket_force_destroy", true)
    lien                 = lookup(local.project_settings, "lien", true)
    bucket_versioning    = lookup(local.project_settings, "bucket_versioning", true)
    folder_id            = lookup(local.project_settings, "folder_id", "00000000")
  }
)