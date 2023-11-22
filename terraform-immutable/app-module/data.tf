data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-b60"
    key    = "terraform-immutable/vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "terraform-b60"
    key    = "terraform-immutable/alb/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "${var.COMPONENT}-${var.APP_VERSION}"
  owners      = ["self"]
}

data "aws_secretsmanager_secret" "secrets" {
  name = var.ENV
}

data "aws_secretsmanager_secret_version" "secrets-version" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}
