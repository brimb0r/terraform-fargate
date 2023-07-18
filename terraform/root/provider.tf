provider "aws" {
  region = var.aws_region
}

terraform {

  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.1"
    }
  }
  required_version = ">=0.14"
}
