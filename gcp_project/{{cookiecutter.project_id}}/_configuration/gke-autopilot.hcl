dependency "service-accounts" {
  config_path = find_in_parent_folders("service-accounts")
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
}

dependencies {
  paths = [
    find_in_parent_folders("service-accounts"),
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
  gke_autopilot_private = {
    "k8s-autopilot-${local.region}" = {
      regional                   = true
      region                     = local.region
      zones                      = local.zones
      network                    = "{{cookiecutter.vpc_name}}"
      subnetwork                 = "{{cookiecutter.subnet_k8s_nodes_prefix}}-${local.region}"
      ip_range_pods              = "{{cookiecutter.subnet_k8s_pods_prefix}}-${local.region}"
      ip_range_services          = "{{cookiecutter.subnet_k8s_services_prefix}}-${local.region}"
      master_ipv4_cidr_block     = "{{cookiecutter.gke_autopilot_master_ipv4_cidr_block}}"
      monitoring_enable_managed_prometheus = false
      add_cluster_firewall_rules = true
      add_master_webhook_firewall_rules = true
      configure_ip_masq = false
      create_service_account = true
      enable_confidential_nodes = true
      enable_network_egress_export = true
      enable_private_nodes = true
      enable_resource_consumption_export = true
      enable_vertical_pod_autoscaling = true
      grant_registry_access = true
      horizontal_pod_autoscaling = true
      http_load_balancing = true
      datapath_provider = "ADVANCED_DATAPATH"
      identity_namespace = "enabled"
      registry_project_ids = []
      kubernetes_version         = "{{cookiecutter.gke_autopilot_kubernetes_version}}"
      firewall_inbound_ports = [
        "80",   # HTTP
        "443",  # HTTPS
        "8080", # Vault
        "8443", # NGINX Ingress
        "10250" # # Kubelet
      ]
      master_authorized_networks = [
        {
          display_name = "{{cookiecutter.gke_autopilot_master_authorized_client_name}}"
          cidr_block   = "{{cookiecutter.gke_autopilot_master_authorized_client_cidr}}"
        },
      ]
    }
  }
}