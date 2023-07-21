### Variable Declerations
#ecs
variable "api_whitelist" { type = list(string) }
variable "aws_region" {}
variable "dns_zone_id" {}
variable "environment" {}
variable "sunrise_container_ingress" { type = list(any) }
variable "sunrise_container_port" {}
variable "web_ssl_cert_arn" {}

#networking
variable "aws_security_groupegress_all" {}
variable "aws_vpc" {}
variable "private_subnet_d" {}
variable "private_subnet_e" {}
variable "public_subnet_d" {}
variable "public_subnet_e" {}