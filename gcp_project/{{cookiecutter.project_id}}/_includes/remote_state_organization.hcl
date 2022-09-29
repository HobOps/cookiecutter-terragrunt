remote_state {
  backend = "gcs"
  generate = {
    path      = "backend_organization.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    prefix         = "${local.org_settings.org_backend_prefix}/projects/${local.project_settings.project_id}"
    bucket         = local.org_settings.org_backend_bucket
    encryption_key = chomp(sops_decrypt_file(find_in_parent_folders("bootstrap/encryption_key.txt")))
  }
}

locals {
  org_settings     = read_terragrunt_config(find_in_parent_folders("org_settings.hcl")).inputs
  project_settings = read_terragrunt_config(find_in_parent_folders("_configuration/project.hcl")).inputs
}
