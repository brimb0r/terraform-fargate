data "aws_region" "current" {}
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "subprod-terraform-state-store-us-east-1"
    dynamodb_table = "subprod-state-store"
    key            = "dev-vpc-us-east-1.tfstate"
    region         = data.aws_region.current.name
  }
}