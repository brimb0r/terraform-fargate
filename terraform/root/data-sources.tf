### Data Sources
data "aws_region" "current" {}

data "aws_vpc" "current" {
  id = var.aws_vpc_id
}