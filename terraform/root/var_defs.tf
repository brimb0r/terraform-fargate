### Variable Declerations
# network
variable "priv_d_cidr_block" {}
variable "priv_e_cidr_block" {}
variable "pub_d_cidr_block" {}
variable "pub_e_cidr_block" {}
variable "vpc_cidr_block" {}
#ecs
variable "api_whitelist" { type = list(string) }
variable "aws_region" {}
variable "dns_zone_id" {}
variable "environment" {}
variable "sunrise_container_ingress" { type = list(any) }
variable "sunrise_container_port" {}
variable "web_ssl_cert_arn" {}

