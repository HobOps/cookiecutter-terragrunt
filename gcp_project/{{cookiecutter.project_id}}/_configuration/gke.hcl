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
  gke = {
    "k8s-${local.region}" = {
      regional                   = true
      region                     = local.region
      zones                      = local.zones
      default_max_pods_per_node  = 110
      network                    = "{{cookiecutter.vpc_name}}"
      subnetwork                 = "{{cookiecutter.subnet_k8s_nodes_prefix}}-${local.region}"
      ip_range_pods              = "{{cookiecutter.subnet_k8s_pods_prefix}}-${local.region}"
      ip_range_services          = "{{cookiecutter.subnet_k8s_services_prefix}}-${local.region}"
      enable_private_nodes       = true
      network_policy             = true
      master_ipv4_cidr_block     = "{{cookiecutter.gke_master_ipv4_cidr_block}}"
      add_cluster_firewall_rules = true
      kubernetes_version         = "{{cookiecutter.gke_kubernetes_version}}"
      firewall_inbound_ports = [
        "80",   # HTTP
        "443",  # HTTPS
        "8080", # Vault
        "8443", # NGINX Ingress
        "10250" # # Kubelet
      ]
      node_pools = [
        {
          name                        = "static-n2d-standard-4"
          machine_type                = "n2d-standard-4"
          node_count                  = 1
          disk_size_gb                = 100
          disk_type                   = "pd-standard"
          image_type                  = "COS_CONTAINERD"
          auto_repair                 = true
          auto_upgrade                = true
          preemptible                 = false
          max_pods_per_node           = 110
          autoscaling                 = false
          node_locations              = join(",", local.zones)
          enable_secure_boot          = true
          enable_integrity_monitoring = true
        },
        {
          name                        = "dynamic-n2d-standard-4"
          machine_type                = "n2d-standard-4"
          min_count                   = 0
          max_count                   = 10
          node_count                  = 0
          disk_size_gb                = 50
          disk_type                   = "pd-standard"
          image_type                  = "COS_CONTAINERD"
          auto_repair                 = true
          auto_upgrade                = true
          preemptible                 = false
          max_pods_per_node           = 110
          autoscaling                 = true
          node_locations              = join(",", local.zones)
          enable_secure_boot          = true
          enable_integrity_monitoring = true
        },
      ]
      node_pools_labels = {
        all = {}
        static-n2d-standard-4 = {
          client = local.client
          prod   = "true"
          static = "true"
        }
        dynamic-n2d-standard-4 = {
          client  = local.client
          prod    = "true"
          dynamic = "true"
        }
      }
      node_pools_metadata = {
        all     = {}
        default = {}
      }
      node_pools_taints = {
        all = []
        dynamic-n2d-standard-4 = [
          {
            key    = "reserved-pool"
            value  = true
            effect = "NO_SCHEDULE"
          },
        ]
      }
      node_pools_tags = {
        all = []
      }
      node_pools_oauth_scopes = {
        all = [
          "https://www.googleapis.com/auth/cloud-platform",
        ]
      }
      master_authorized_networks = [
        {
          display_name = "{{cookiecutter.gke_master_authorized_client_name}}"
          cidr_block   = "{{cookiecutter.gke_master_authorized_client_cidr}}"
        },
      ]
    }
  }
}