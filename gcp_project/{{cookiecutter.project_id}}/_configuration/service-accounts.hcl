dependencies {
  paths = [
    find_in_parent_folders("project")
  ]
}

locals {
  # Import variables
  org_settings     = read_terragrunt_config(find_in_parent_folders("org_settings.hcl")).inputs
  project_settings = read_terragrunt_config(find_in_parent_folders("_configuration/project.hcl")).inputs
  client           = local.project_settings.client
  project_id       = local.project_settings.project_id
  region           = local.project_settings.region
  zone             = local.project_settings.zone
  zones            = local.project_settings.zones

  # Module variables
}

terraform {
  source = "{{cookiecutter.__terraform_module_resources_version}}"
}

inputs = {
  service_accounts = {
    "{{cookiecutter.service_account_name}}" = {
      generate_keys = true
    }
  }
}
