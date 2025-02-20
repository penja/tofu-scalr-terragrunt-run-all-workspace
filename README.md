# tofu-scalr-terragrunt-run-all-workspace
This OpenTofu module provisions a Scalr environment, workspace, and provider configuration for running terragrunt run-all commands.

It supports flexible remote state management by either integrating with an existing S3 bucket, DynamoDB table, and IAM role for OIDC authentication or automatically creating these resources via the tofu-aws-scalr-managed-s3-backend module:
- Custom Remote State Backend: Use your existing S3 bucket, DynamoDB table, and IAM role by specifying:
  - role_arn: IAM Role ARN for OIDC authentication.
  - bucket_name: S3 bucket for storing state files.
  - dynamodb_table_name: DynamoDB table for Tofu state locks.
 - Automated Backend Provisioning: Set create_s3_backend = true to automatically create an S3 bucket, DynamoDB table, and IAM role using the tofu-aws-scalr-managed-s3-backend module.

## 🛠 Prerequisites
 - VCS Provider in Scalr: You must create a VCS provider in Scalr and provide its ID via:
```
variable "vcs_repo_config" {
  type = object({
    vcs_provider_id  = string
    identifier       = string
    branch           = string
    trigger_prefixes = list(string)
  })
  description = "Scalr VCS provider ID and repository details for Terragrunt code."
}
```
 - Terragrunt Integration: Scalr does not currently have a native Terragrunt integration resource in its provider. You must manually enable Terragrunt integration via the Scalr UI or API.
 - AWS credentials configured
 - Scalr credentials configured


Example of tfvas file for this module:
```tfvars
scalr_hostname              = "mainiacp.scalr.io"
scalr_account_name          = "mainiacp"
scalr_account_id            = "acc-svrcncgh453bi8g"
scalr_environment_name      = "terragrunt-test"
scalr_workspace_name        = "terragrunt-test"
workspace_working_directory = "envs/dev"
vcs_repo_config = {
  vcs_provider_id  = "vcs-v0on7njhcas4958n9"
  identifier       = "DayS1eeper/scalr-terragrunt-run-all-test"
  branch           = "units-deletion-test"
  trigger_prefixes = ["envs/dev", "modules"]
}
create_s3_backend = true
workspace_terragrunt = {
  version                       = "0.73.7"
  use_run_all                   = true
  include_external_dependencies = false
}
enable_s3_encryption = false
enable_dynamodb_pitr = false
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_scalr"></a> [scalr](#requirement\_scalr) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_scalr"></a> [scalr](#provider\_scalr) | 2.5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_backend"></a> [s3\_backend](#module\_s3\_backend) | github.com/DayS1eeper/tofu-aws-scalr-managed-s3-backend | n/a |

## Resources

| Name | Type |
|------|------|
| scalr_environment.this | resource |
| scalr_provider_configuration.s3_remote_state_credentials | resource |
| scalr_variable.backend_bucket | resource |
| scalr_variable.dynamodb_lock_table | resource |
| scalr_workspace.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of S3 bucket to store the state files | `string` | `null` | no |
| <a name="input_create_s3_backend"></a> [create\_s3\_backend](#input\_create\_s3\_backend) | Enable the S3 backend module for state management. If enabled, s3 bucket for storing state and dynamodb for locks will be created. | `bool` | n/a | yes |
| <a name="input_dynamodb_table_name"></a> [dynamodb\_table\_name](#input\_dynamodb\_table\_name) | The name of dynamodb table for tofu locks, used if S3 backend module is disabled. | `string` | `null` | no |
| <a name="input_enable_dynamodb_pitr"></a> [enable\_dynamodb\_pitr](#input\_enable\_dynamodb\_pitr) | Enable Point-in-Time Recovery for DynamoDB table | `bool` | `false` | no |
| <a name="input_enable_s3_encryption"></a> [enable\_s3\_encryption](#input\_enable\_s3\_encryption) | Enable server-side encryption for S3 bucket | `bool` | `false` | no |
| <a name="input_iac_platform"></a> [iac\_platform](#input\_iac\_platform) | The IaC platform to use for this workspace. Valid values are terraform and opentofu. | `string` | `"opentofu"` | no |
| <a name="input_oidc_aud_value"></a> [oidc\_aud\_value](#input\_oidc\_aud\_value) | n/a | `string` | `"aws.scalr-run-workload"` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | IAM Role ARN for OIDC authentication, used if S3 backend module is disabled. | `string` | `null` | no |
| <a name="input_scalr_account_id"></a> [scalr\_account\_id](#input\_scalr\_account\_id) | Scalr account ID | `string` | n/a | yes |
| <a name="input_scalr_account_name"></a> [scalr\_account\_name](#input\_scalr\_account\_name) | Scalr account name | `string` | n/a | yes |
| <a name="input_scalr_environment_name"></a> [scalr\_environment\_name](#input\_scalr\_environment\_name) | Scalr environment name | `string` | n/a | yes |
| <a name="input_scalr_hostname"></a> [scalr\_hostname](#input\_scalr\_hostname) | Scalr hostname | `string` | n/a | yes |
| <a name="input_scalr_workspace_name"></a> [scalr\_workspace\_name](#input\_scalr\_workspace\_name) | Scalr workspace name | `string` | `"run-all-test"` | no |
| <a name="input_vcs_repo_config"></a> [vcs\_repo\_config](#input\_vcs\_repo\_config) | Sclar VCS provider with the configurations of the repository with terragrunt code. | <pre>object({<br>    vcs_provider_id  = string<br>    identifier       = string<br>    branch           = string<br>    trigger_prefixes = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_workspace_terragrunt"></a> [workspace\_terragrunt](#input\_workspace\_terragrunt) | The Scalr workspace terragrunt settings. | <pre>object({<br>    version                       = string<br>    use_run_all                   = bool<br>    include_external_dependencies = bool<br>  })</pre> | n/a | yes |
| <a name="input_workspace_working_directory"></a> [workspace\_working\_directory](#input\_workspace\_working\_directory) | The directory in which the terragrunt run-all command should be executed to manage multiple Terragrunt configurations in parallel. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->