locals {
  ssh_user   = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["SSH_USER"])
  ssh_pass   = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["SSH_PASS"])
  NEXUS_USER = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["NEXUS_USER"])
  NEXUS_PASS = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["NEXUS_PASS"])
}
