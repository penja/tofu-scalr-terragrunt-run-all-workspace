variable "scalr_hostname" {
  description = "Scalr hostname"
  type        = string
}

variable "scalr_account_name" {
  type        = string
  description = "Scalr account name"
}

variable "scalr_account_id" {
  type        = string
  description = "Scalr account ID"
}

variable "oidc_aud_value" {
  type    = string
  default = "aws.scalr-run-workload"
}

variable "scalr_environment_name" {
  type        = string
  description = "Scalr environment name"
}

variable "scalr_workspace_name" {
  type        = string
  default     = "run-all-test"
  description = "Scalr workspace name"
}

variable "workspace_working_directory" {
  type        = string
  description = "The directory in which the terragrunt run-all command should be executed to manage multiple Terragrunt configurations in parallel."
}

variable "vcs_repo_config" {
  type = object({
    vcs_provider_id  = string
    identifier       = string
    branch           = string
    trigger_prefixes = list(string)
  })
  description = "Sclar VCS provider with the configurations of the repository with terragrunt code."
}

variable "role_arn" {
  type        = string
  description = "IAM Role ARN for OIDC authentication, used if S3 backend module is disabled."
  default     = null
}

variable "create_s3_backend" {
  type        = bool
  description = "Enable the S3 backend module for state management. If enabled, s3 bucket for storing state and dynamodb for locks will be created."
}

variable "workspace_terragrunt" {
  type = object({
    version                       = string
    use_run_all                   = bool
    include_external_dependencies = bool
  })
  description = "The Scalr workspace terragrunt settings."
}

variable "iac_platform" {
  type        = string
  default     = "opentofu"
  description = "The IaC platform to use for this workspace. Valid values are terraform and opentofu."
}

variable "bucket_name" {
  description = "The name of S3 bucket to store the state files"
  type        = string
  default     = null
}

variable "dynamodb_table_name" {
  description = "The name of dynamodb table for tofu locks."
  type        = string
  default     = null
}

variable "enable_s3_encryption" {
  description = "Enable server-side encryption for S3 bucket"
  type        = bool
  default     = false
}

variable "enable_dynamodb_pitr" {
  description = "Enable Point-in-Time Recovery for DynamoDB table"
  type        = bool
  default     = false
}
