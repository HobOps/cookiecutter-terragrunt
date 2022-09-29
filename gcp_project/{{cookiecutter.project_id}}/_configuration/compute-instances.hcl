dependency "service-accounts" {
  config_path = find_in_parent_folders("service-accounts")
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
}

dependency "cloud-nat-router" {
  config_path = find_in_parent_folders("cloud-nat-router")
  mock_outputs = {}
}

dependencies {
  paths = [
    find_in_parent_folders("service-accounts"),
    find_in_parent_folders("vpc"),
    find_in_parent_folders("cloud-nat-router")
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
  org_ssh_keys     = lookup(local.org_settings, "org_ssh_keys", "")
  project_ssh_keys = lookup(local.project_settings, "project_ssh_keys", "")
  instance_tags = {
    default_tags = ["ssh", "ping", "server"]
  }
}

inputs = {
  compute_instances = {
    "example-instance-${local.region}" = {
      labels             = {}
      instance_image     = "ubuntu-os-cloud/ubuntu-minimal-2204-jammy-v20220902"
      instance_disk_size = 32
      machine_type       = "e2-micro"
      instance_tags      = local.instance_tags["default_tags"]
      metadata = {
        ssh-keys = join("\n", [local.org_ssh_keys, local.project_ssh_keys])
      }
      subnetwork     = dependency.vpc.outputs.vpc["{{cookiecutter.vpc_name}}"].subnets["${local.region}/{{cookiecutter.subnet_management_prefix}}-${local.region}"].name
      public_ip      = true
      can_ip_forward = true
    }
  }
}