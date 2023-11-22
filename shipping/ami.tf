terraform {
  backend "s3" {
    bucket = "terraform-b60"
    key    = "terraform-ami/shipping/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "ami" {
  source      = "git::https://DevOps-Batches@dev.azure.com/DevOps-Batches/DevOps60/_git/terraform-ami"
  COMPONENT   = "shipping"
  APP_VERSION = var.APP_VERSION
}

variable "APP_VERSION" {}
