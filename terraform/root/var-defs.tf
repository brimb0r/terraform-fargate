### Variable Declerations
variable "aws_region" {}
variable "api_whitelist" { type = list(string) }
variable "dns_zone_id" {}
variable "environment" {}
variable "web_ssl_cert_arn" {}
