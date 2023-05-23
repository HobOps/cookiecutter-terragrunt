terraform {
  source = "{{cookiecutter.__terraform_module_google_factory_version}}"
}

inputs = {
  project_id              = "{{cookiecutter.project_id}}"
  tfstate_prefix          = "{{cookiecutter.tfstate_prefix}}"
  region                  = "{{cookiecutter.project_default_region}}"
  zone                    = "{{cookiecutter.project_primary_zone}}"
  zones                   = ["{{cookiecutter.project_primary_zone}}", "{{cookiecutter.project_secondary_zone}}"]
  folder_id               = "{{cookiecutter.folder_id}}"
  billing_account         = "{{cookiecutter.project_billing_account}}"
  activate_apis           = []
  client                  = "{{cookiecutter.client_name}}"
  project_ssh_keys        = "{{cookiecutter.project_ssh_keys}}"
  default_service_account = "keep"
}
