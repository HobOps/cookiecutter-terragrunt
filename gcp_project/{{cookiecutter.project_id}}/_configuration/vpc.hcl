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
  vpc = {
    {{cookiecutter.vpc_name}} = {
      subnets = [
        {
          subnet_name               = "{{cookiecutter.subnet_management_prefix}}-${local.region}"
          subnet_ip                 = "{{cookiecutter.subnet_management_cidr}}"
          subnet_region             = "${local.region}"
          subnet_private_access     = true
          subnet_flow_logs          = false
          subnet_flow_logs_interval = "INTERVAL_1_MIN"
          subnet_flow_logs_sampling = 1
          subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        },
        {
          subnet_name               = "{{cookiecutter.subnet_k8s_nodes_prefix}}-${local.region}"
          subnet_ip                 = "{{cookiecutter.subnet_k8s_nodes_cidr}}"
          subnet_region             = "${local.region}"
          subnet_private_access     = true
          subnet_flow_logs          = false
          subnet_flow_logs_interval = "INTERVAL_1_MIN"
          subnet_flow_logs_sampling = 1
          subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        },
      ]
      secondary_ranges = {
        "{{cookiecutter.subnet_k8s_nodes_prefix}}-${local.region}" = [
          {
            range_name    = "{{cookiecutter.subnet_k8s_pods_prefix}}-${local.region}"
            ip_cidr_range = "{{cookiecutter.subnet_k8s_pods_cidr}}"
          },
          {
            range_name    = "{{cookiecutter.subnet_k8s_services_prefix}}-${local.region}"
            ip_cidr_range = "{{cookiecutter.subnet_k8s_services_cidr}}"
          },
        ]
      }
      firewall_rules = [
        {
          name                    = "example-ingress-rule"
          description             = "Example ingress rule"
          direction               = "INGRESS"
          priority                = 100
          ranges                  = ["192.168.0.0/24"]
          source_tags             = null
          source_service_accounts = null
          target_tags             = ["server"]
          target_service_accounts = null
          allow = [
            {
              protocol = "tcp"
              ports    = ["80", "443"]
            },
            {
              protocol = "icmp"
              ports    = null
            }
          ]
          deny = []
          log_config = {
            metadata = "INCLUDE_ALL_METADATA"
          }
        }
      ]
    }
  }
  {% set private_service_access_cidr = cookiecutter.private_service_access.split('/') %}
  private_service_access = {
    "{{cookiecutter.vpc_name}}" = {
      address       = "{{private_service_access_cidr[0]}}"
      prefix_length = "{{private_service_access_cidr[1]}}"
    }
  }
}
