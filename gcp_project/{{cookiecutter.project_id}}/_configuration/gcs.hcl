dependency "service-accounts" {
  config_path = find_in_parent_folders("service-accounts")
}

dependencies {
  paths = [
    find_in_parent_folders("service-accounts")
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

inputs = {
  gcs_buckets = {
    "${local.client}-example-bucket" = {
      randomize_suffix = true
      admins = [
        "serviceAccount:${dependency.service-accounts.outputs.service_accounts["{{cookiecutter.service_account_name}}"].service_accounts[0].email}"
      ]
    }
  }
}