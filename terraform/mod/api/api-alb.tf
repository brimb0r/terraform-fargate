module "api-lb-primary" {
  source            = "../alb"
  lb_name           = format("api-%s-%s", var.environment, var.aws_region)
  name              = "api"
  environment       = var.environment
  subnet_ids        = [var.public_e, var.public_d]
  web_ssl_cert_arn  = var.web_ssl_cert_arn
  vpc_id            = var.aws_vpc_id
  dns_zone_id       = var.dns_zone_id
  dns_zone_value    = "api-${var.dns_zone_value}"
  internal          = false
  ingress_whitelist = var.api_whitelist
  ingress_rules_http = [
    [80, 80, "tcp", "LB can be reached by this"],
    [3000, 3000, "tcp", "LB can be reached by this"]
  ]
  ingress_rules_https = [
    # [from_port, to_port, protocol, description]
    [443, 443, "tcp", "LB can be reached by this"],
    [3000, 3000, "tcp", "LB can hit this"]
  ]
  listener_targets = [
    { lb_port = 443, lb_proto = "HTTPS", be_port = 3000, be_proto = "HTTP" },
  ]
}