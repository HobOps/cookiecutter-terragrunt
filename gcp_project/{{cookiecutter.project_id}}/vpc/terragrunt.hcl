include "remote_state_project" {
  path           = find_in_parent_folders("_includes/remote_state_project.hcl")
  merge_strategy = "deep"
}

include "provider_gcp_project" {
  path           = find_in_parent_folders("_includes/provider_gcp_project.hcl")
  merge_strategy = "deep"
}

terraform {
  source = "{{cookiecutter.__terraform_module_resources_version}}"
}

locals {
  current_module = basename(get_terragrunt_dir())
}

inputs = merge(
  read_terragrunt_config(find_in_parent_folders("_configuration/project.hcl")).inputs,
  read_terragrunt_config(find_in_parent_folders("_configuration/${local.current_module}.hcl")).inputs
)

dependencies {
  paths = read_terragrunt_config(find_in_parent_folders("_configuration/${local.current_module}.hcl")).dependencies.paths
}