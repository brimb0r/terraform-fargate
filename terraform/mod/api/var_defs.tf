locals {
  internal_cidr = data.aws_vpc.current.cidr_block
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpc" "current" { id = var.aws_vpc_id }


variable "api_dns_value" {}
variable "api_image" {}
variable "api_whitelist" { type = list(string) }
variable "aws_region" {}
variable "aws_vpc_id" {}
variable "desired_count" { default = 2 }
variable "dns_zone_id" {}
variable "dns_zone_value" {}
variable "environment" {}
variable "log_script_filter" { default = 1 }
variable "web_ssl_cert_arn" {}


variable "aws_security_groupegress_all" {}
variable "aws_security_groupingress_api" {}
variable "aws_vpc" {}
variable "private_d" {}
variable "private_e" {}
variable "public_d" {}
variable "public_e" {}