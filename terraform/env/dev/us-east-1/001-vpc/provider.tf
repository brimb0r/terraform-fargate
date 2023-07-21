provider "aws" {
  region = "us-east-1"
}

terraform {

  backend "s3" {
    encrypt        = true
    bucket         = "subprod-terraform-state-store-us-east-1"
    dynamodb_table = "subprod-state-store"
    key            = "dev-vpc-us-east-1.tfstate"
    region         = "us-east-1"
  }
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
