remote_state {
  backend = "gcs"
  generate = {
    path      = "backend_project.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    prefix         = "${basename(get_terragrunt_dir())}"
    bucket         = lookup(local.project_settings, "project_bucket", "${local.project_settings.project_id}-tfstate")
    encryption_key = chomp(sops_decrypt_file(find_in_parent_folders("bootstrap/encryption_key.txt")))
  }
}

locals {
  project_settings = read_terragrunt_config(find_in_parent_folders("_configuration/project.hcl")).inputs
}
