# Description
These commands can be used to import existing resources to terragrunt

# Usage
Execute the following commands on the correct directory

## vpc
### network
```
terragrunt import 'module.vpc["{{cookiecutter.vpc_name}}"].module.vpc.google_compute_network.network' /projects/{{cookiecutter.project_id}}/global/networks/{{cookiecutter.vpc_name}}```
```
### subnets
```
terragrunt import 'module.vpc["{{cookiecutter.vpc_name}}"].module.subnets.google_compute_subnetwork.subnetwork["{{cookiecutter.project_default_region}}/{{cookiecutter.subnet_k8s_nodes_prefix}}-{{cookiecutter.project_default_region}}"]' projects/{{cookiecutter.project_id}}/regions/{{cookiecutter.project_default_region}}/subnetworks/{{cookiecutter.subnet_k8s_nodes_prefix}}-{{cookiecutter.project_default_region}}
terragrunt import 'module.vpc["{{cookiecutter.vpc_name}}"].module.subnets.google_compute_subnetwork.subnetwork["{{cookiecutter.project_default_region}}/{{cookiecutter.subnet_management_prefix}}-{{cookiecutter.project_default_region}}"]' projects/{{cookiecutter.project_id}}/regions/{{cookiecutter.project_default_region}}/subnetworks/{{cookiecutter.subnet_management_prefix}}-{{cookiecutter.project_default_region}}
```
### firewall rules
```
terragrunt import 'module.default_firewall_rules["{{cookiecutter.vpc_name}}"].google_compute_firewall.rules["allow-kubernetes-ports"]' projects/{{cookiecutter.project_id}}/global/firewalls/allow-kubernetes-ports
terragrunt import 'module.default_firewall_rules["{{cookiecutter.vpc_name}}"].google_compute_firewall.rules["allow-nginx-ingress"]' projects/{{cookiecutter.project_id}}/global/firewalls/allow-nginx-ingress
terragrunt import 'module.default_firewall_rules["{{cookiecutter.vpc_name}}"].google_compute_firewall.rules["allow-ping"]' projects/{{cookiecutter.project_id}}/global/firewalls/allow-ping
terragrunt import 'module.default_firewall_rules["{{cookiecutter.vpc_name}}"].google_compute_firewall.rules["allow-ssh"]' projects/{{cookiecutter.project_id}}/global/firewalls/allow-ssh
terragrunt import 'module.default_firewall_rules["{{cookiecutter.vpc_name}}"].google_compute_firewall.rules["allow-webserver"]' projects/{{cookiecutter.project_id}}/global/firewalls/allow-webserver
```
### private-service-access
```
terragrunt import 'module.private-service-access["{{cookiecutter.vpc_name}}"].google_compute_global_address.google-managed-services-range' projects/{{cookiecutter.project_id}}/global/addresses/google-managed-services-{{cookiecutter.vpc_name}}
terragrunt import 'module.private-service-access["{{cookiecutter.vpc_name}}"].google_service_networking_connection.private_service_access' /projects/{{cookiecutter.project_id}}/global/networks/{{cookiecutter.vpc_name}}:servicenetworking.googleapis.com
```

## network-addresses
```
terragrunt import 'module.addresses["ip-nat-{{cookiecutter.project_default_region}}"].google_compute_address.ip[0]' projects/{{cookiecutter.project_id}}/regions/{{cookiecutter.project_default_region}}/addresses/ip-nat-{{cookiecutter.project_default_region}}
terragrunt import 'module.addresses["ip-loadbalancer"].google_compute_address.ip[0]' projects/{{cookiecutter.project_id}}/regions/{{cookiecutter.project_default_region}}/addresses/ip-loadbalancer
```

## cloud-nat-router
### router
```
terragrunt import 'module.cloud_router["router-{{cookiecutter.project_default_region}}"].google_compute_router.router' projects/{{cookiecutter.project_id}}/regions/{{cookiecutter.project_default_region}}/routers/router-{{cookiecutter.project_default_region}}
```
### cloud-nat
```
terragrunt import 'module.cloud_router["router-{{cookiecutter.project_default_region}}"].google_compute_router_nat.nats["nat-{{cookiecutter.project_default_region}}"]' projects/{{cookiecutter.project_id}}/regions/{{cookiecutter.project_default_region}}/routers/router-{{cookiecutter.project_default_region}}/nat-{{cookiecutter.project_default_region}}
```

## gke
### cluster
```
terragrunt import 'module.gke["k8s-{{cookiecutter.project_default_region}}"].google_container_cluster.primary' projects/{{cookiecutter.project_id}}/locations/{{cookiecutter.project_default_region}}/clusters/k8s-{{cookiecutter.project_default_region}}
```

### node pool
```
terragrunt import 'module.gke["k8s-{{cookiecutter.project_default_region}}"].google_container_node_pool.pools["dynamic-n2d-standard-4"]' {{cookiecutter.project_id}}/{{cookiecutter.project_default_region}}/k8s-{{cookiecutter.project_default_region}}/dynamic-n2d-standard-4
terragrunt import 'module.gke["k8s-{{cookiecutter.project_default_region}}"].google_container_node_pool.pools["static-n2d-standard-4"]' {{cookiecutter.project_id}}/{{cookiecutter.project_default_region}}/k8s-{{cookiecutter.project_default_region}}/static-n2d-standard-4
```

### firewall rules
```
terragrunt import 'module.gke["k8s-{{cookiecutter.project_default_region}}"].google_compute_firewall.master_webhooks[0]' projects/{{cookiecutter.project_id}}/global/firewalls/gke-k8s-{{cookiecutter.project_default_region}}-webhooks
terragrunt import 'module.gke["k8s-{{cookiecutter.project_default_region}}"].google_compute_firewall.intra_egress[0]' projects/{{cookiecutter.project_id}}/global/firewalls/gke-k8s-{{cookiecutter.project_default_region}}-intra-cluster-egress
```