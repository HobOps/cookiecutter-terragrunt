dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
}

dependency "network-addresses" {
  config_path = find_in_parent_folders("network-addresses")
}

dependencies {
  paths = [
    find_in_parent_folders("vpc"),
    find_in_parent_folders("network-addresses")
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
  cloud_nat_routers = {
    "router-${local.region}" = {
      cloud_nat_name = "nat-${local.region}"
      nat_ips        = dependency.network-addresses.outputs.addresses["ip-nat-${local.region}"].self_links
      network        = dependency.vpc.outputs.vpc["{{cookiecutter.vpc_name}}"].network_name
    }
  }
}
