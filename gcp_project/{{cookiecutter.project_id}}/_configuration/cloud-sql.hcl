dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
}

dependencies {
  paths = [
    find_in_parent_folders("vpc")
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
  secrets = yamldecode(sops_decrypt_file(find_in_parent_folders("_configuration/cloud-sql.secrets.yaml")))
}

terraform {
  source = "{{cookiecutter.__terraform_module_resources_version}}"
}

inputs = {
  cloud_sql_postgresql = {
    "${local.client}-postgres-common" = {
      database_version    = "{{cookiecutter.postgres_version}}"
      private_network     = dependency.vpc.outputs.vpc["{{cookiecutter.vpc_name}}"].network_id
      availability_type   = "{{cookiecutter.postgres_availability}}"
      deletion_protection = "true"
      ipv4_enabled        = "false"
      user_name           = local.secrets["cloud_sql_postgresql"].user_name
      user_password       = local.secrets["cloud_sql_postgresql"].user_password
      database_flags = [
        {
          name  = "max_connections"
          value = "2000"
        }
      ]
      authorized_networks = [
        {
          name  = "example_client"
          value = "8.8.8.8/32"
        }
      ]
    }
  }
}
