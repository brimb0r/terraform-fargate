### Variable Declerations
#ecs
variable "api_whitelist" { type = list(string) }
variable "aws_region" {}
variable "dns_zone_id" {}
variable "environment" {}
variable "sunrise_container_ingress" { type = list(any) }
variable "sunrise_container_port" {}
variable "web_ssl_cert_arn" {}