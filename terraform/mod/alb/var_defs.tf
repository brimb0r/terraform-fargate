variable "environment" {}

variable "subnet_ids" {
  type = list(string)
}

variable "web_ssl_cert_arn" {}

variable "vpc_id" {}

variable "dns_zone_id" {}

variable "dns_zone_value" {}

variable "name" {}

variable "internal" {
  default = false
}

variable "ingress_whitelist" {
  type = list(any)
}

variable "health_check_enabled" { default = true }
variable "health_check_healthy_threshold" { default = 2 }
variable "health_check_unhealthy_threshold" { default = 2 }
variable "health_check_interval" { default = 10 }
variable "health_check_timeout" { default = 5 }
variable "health_check_matcher" { default = 200 }
variable "health_check_port" { default = "traffic-port" }
variable "health_check_path" { default = "/" }
variable "lb_name" {}
variable "ingress_rules_http" {
  type = list(any)
}

variable "ingress_rules_https" {
  type = list(any)
}

variable "listener_targets" {
  type = list(any)
}

variable "idle_timeout" { default = 60 }
