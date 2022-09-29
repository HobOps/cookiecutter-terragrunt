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
}

inputs = {
  addresses = {
    "ip-internal-loadbalancer-${local.region}" = {
      region       = local.region
      address_type = "INTERNAL"
      subnetwork   = dependency.vpc.outputs.vpc["{{cookiecutter.vpc_name}}"].subnets["${local.region}/{{cookiecutter.subnet_k8s_nodes_prefix}}-${local.region}"].name
    }
    "ip-nat-${local.region}" = {
      region = local.region
    }
    "ip-loadbalancer" = {
      region = local.region
    }
  }
}
