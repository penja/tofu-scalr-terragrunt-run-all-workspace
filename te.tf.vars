scalr_hostname              = "mainiacp.scalr.io"
scalr_account_name          = "mainiacp"
scalr_account_id            = "acc-svrcncgh453bi8g"
scalr_environment_name      = "terragrunt-test"
scalr_workspace_name        = "terragrunt-test"
workspace_working_directory = "envs/dev"
vcs_repo_config = {
  vcs_provider_id  = "vcs-v0onqo76dnhuajsto"
  identifier       = "penja/scalr-terragrunt-run-all-test"
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