# Description

# Dependencies
- sops
- cookiecutter
- tgenv
- tfenv
- 
# Usage
## Create GCP organization
```bash
cookiecutter https://github.com/HobOps/cookiecutter-terragrunt --directory gcp_organization -o organizations
```

## Create GCP project
```bash
cookiecutter https://github.com/HobOps/cookiecutter-terragrunt --directory gcp_project -o organizations/example.com/projects
```


# Known issues
## Increase billing account project quota (5 by defaylt)
```
╷
│ Error: Error setting billing account "XXXXXX-XXXXXX-XXXXXX" for project "projects/example-project-20220105": googleapi: Error 400: Precondition check failed.
│ Details:
│ [
│   {
│     "@type": "type.googleapis.com/google.rpc.QuotaFailure",
│     "violations": [
│       {
│         "description": "Cloud billing quota exceeded: https://support.google.com/code/contact/billing_quota_increase",
│         "subject": "billingAccounts/XXXXXX-XXXXXX-XXXXXX"
│       }
│     ]
│   }
│ ]
│ , failedPrecondition
```

## 
folder_id


## Slow and no progress
Check for circular dependencies