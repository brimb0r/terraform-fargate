resource "aws_route53_record" "dns_name" {
  zone_id = var.dns_zone_id
  name    = var.api_dns_value
  type    = "A"
  alias {
    evaluate_target_health = false
    name                   = "api-${var.dns_zone_value}"
    zone_id                = var.dns_zone_id
  }
  depends_on = [module.api-lb-primary]
}