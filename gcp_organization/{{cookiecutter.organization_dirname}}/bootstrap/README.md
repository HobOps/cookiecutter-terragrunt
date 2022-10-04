We need to create the following resources using gcloud:
- Create the initial project and set billing account
- Create the initial bucket
- Create the initial KMS
- Default terraform encryption_key and encrypting it using SOPS

# Instructions
- Define terraform project variables
```bash
export ORG_BASE_DIRNAME="{{cookiecutter.organizations_base_dirname}}"
export ORG_DIRNAME="{{cookiecutter.organization_dirname}}"
export ORG_ID="{{cookiecutter.org_id}}"
export PROJECT_ID="{{cookiecutter.terraform_project}}"
export BILLING_ACCOUNT="{{cookiecutter.terraform_project_billing_account}}"
export BUCKET_NAME="{{cookiecutter.terraform_bucket_name}}"
export BUCKET_REGION="{{cookiecutter.terraform_bucket_region}}"
export KMS_KEYRING="{{cookiecutter.terraform_kms_keyring}}"
export KMS_KEY="{{cookiecutter.terraform_kms_key}}"
```

- Go to organization directory
```bash
cd ${ORG_BASE_DIRNAME}/${ORG_DIRNAME}
```

- Create the initial project and set billing account
```bash
gcloud projects create ${PROJECT_ID} --organization=${ORG_ID}
gcloud beta billing projects link ${PROJECT_ID} --billing-account=${BILLING_ACCOUNT}
```

- Create the initial bucket
```bash
gsutil mb -p ${PROJECT_ID} -c "STANDARD" -l "${BUCKET_REGION}" -b on gs://${BUCKET_NAME}
gsutil versioning set on gs://${BUCKET_NAME}

```

- Create initial KMS
```bash
gcloud services enable cloudkms.googleapis.com --project ${PROJECT_ID}
gcloud kms keyrings create ${KMS_KEYRING} --location global --project ${PROJECT_ID}
gcloud kms keys create ${KMS_KEY} --location global --keyring ${KMS_KEYRING} --purpose encryption --project ${PROJECT_ID}
gcloud kms keys list --location global --keyring ${KMS_KEYRING} --project ${PROJECT_ID}
```

- Default terraform encryption_key and encrypting it using SOPS
```bash
# Generate encryption key
export ENCRYPTION_KEY=$(python3 -c 'import os;import base64;print(base64.b64encode(os.urandom(32)).decode("utf-8"))')

# Get KMS path
export KMS_NAME=$(gcloud kms keys list --location global --keyring ${KMS_KEYRING} --project ${PROJECT_ID} --format text | grep "^name:" | awk '{print $2}' | grep "${KMS_KEY}$")
echo "${ENCRYPTION_KEY}" | sops --encrypt --gcp-kms ${KMS_NAME} /dev/stdin > ./bootstrap/encryption_key.txt
```
