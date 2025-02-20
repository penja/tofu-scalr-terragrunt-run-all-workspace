provider "scalr" {
  hostname = var.scalr_hostname
}

locals {
  bucket_name     = var.create_s3_backend ? module.s3_backend[0].bucket_name : var.bucket_name
  lock_table_name = var.create_s3_backend ? module.s3_backend[0].table_name : var.dynamodb_table_name
}

module "s3_backend" {
  count  = var.create_s3_backend ? 1 : 0
  source = "github.com/DayS1eeper/tofu-aws-scalr-managed-s3-backend"

  bucket_name            = var.bucket_name
  dynamodb_table_name    = var.dynamodb_table_name
  enable_s3_encryption   = var.enable_s3_encryption
  enable_dynamodb_pitr   = var.enable_dynamodb_pitr
  scalr_hostname         = regex("^[^.]+\\.(.+)$", var.scalr_hostname)[0] // Remove account part from URL
  oidc_aud_value         = var.oidc_aud_value
  scalr_account_name     = var.scalr_account_name
  scalr_environment_name = var.scalr_environment_name
}

resource "scalr_environment" "this" {
  name           = var.scalr_environment_name
  account_id     = var.scalr_account_id
  remote_backend = false
}

resource "scalr_provider_configuration" "s3_remote_state_credentials" {
  name                   = "s3_remote_state_credentials"
  account_id             = var.scalr_account_id
  export_shell_variables = true
  environments           = [scalr_environment.this.id]
  aws {
    credentials_type = "oidc"
    role_arn         = var.create_s3_backend ? module.s3_backend[0].scalr_role_arn : var.role_arn
    audience         = var.oidc_aud_value
  }
}

resource "scalr_workspace" "this" {
  name              = var.scalr_workspace_name
  environment_id    = scalr_environment.this.id
  vcs_provider_id   = var.vcs_repo_config.vcs_provider_id
  working_directory = var.workspace_working_directory
  type              = "development"
  iac_platform      = var.iac_platform

  vcs_repo {
    identifier       = var.vcs_repo_config.identifier
    branch           = var.vcs_repo_config.branch
    trigger_prefixes = var.vcs_repo_config.trigger_prefixes
  }
  provider_configuration {
    id = scalr_provider_configuration.s3_remote_state_credentials.id
  }
  terragrunt {
    version                       = var.workspace_terragrunt.version
    use_run_all                   = var.workspace_terragrunt.use_run_all
    include_external_dependencies = var.workspace_terragrunt.include_external_dependencies
  }
}

resource "scalr_variable" "backend_bucket" {
  key          = "BACKEND_BUCKET_NAME"
  value        = local.bucket_name
  category     = "shell"
  description  = "The bucket for storing state fiels."
  account_id   = var.scalr_account_id
  workspace_id = scalr_workspace.this.id
}

resource "scalr_variable" "dynamodb_lock_table" {
  key          = "BACKEND_DYNAMODB_TABLE_NAME"
  value        = local.lock_table_name
  category     = "shell"
  description  = "The dynamodb table for tofu locks."
  account_id   = var.scalr_account_id
  workspace_id = scalr_workspace.this.id
}
