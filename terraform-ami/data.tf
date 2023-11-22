data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "base"
  owners      = ["self"]
}

data "aws_secretsmanager_secret" "secrets" {
  name = "dev"
}

data "aws_secretsmanager_secret_version" "secrets-version" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}