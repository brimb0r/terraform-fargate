### Variable Declerations
variable "aws_private_subnets" {}
variable "aws_public_subnets" {}
variable "aws_region" {}
variable "aws_vpc_id" {}
variable "api_whitelist" { type = list(string) }
variable "dns_zone_id" {}
variable "environment" {}
variable "web_ssl_cert_arn" {}
