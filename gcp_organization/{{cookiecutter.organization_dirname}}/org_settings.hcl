inputs = {
  org_backend_project = "{{cookiecutter.terraform_project}}"
  org_backend_bucket = "{{cookiecutter.terraform_bucket_name}}"
  org_backend_prefix = "{{cookiecutter.terraform_backend_prefix}}"
  org_backend_region = "{{cookiecutter.terraform_backend_region}}"
  org_id = "{{cookiecutter.org_id}}"
  org_activate_apis = [
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "securetoken.googleapis.com",
    "servicemanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "storage-api.googleapis.com",
    "storage.googleapis.com",
    "vpcaccess.googleapis.com",
  ]
  org_ssh_keys = "{{cookiecutter.org_ssh_keys}}"
}
