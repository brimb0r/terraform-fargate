module "api" {
  source                       = "../../mod/api"
  api_dns_value                = format("%s-%s-api.coast-test.%s", var.environment, var.aws_region, var.environment == "prod" ? "com" : "net")
  api_image                    = "public.ecr.aws/u8j1b7o3/coast-test-go:latest"
  api_whitelist                = var.api_whitelist
  aws_region                   = var.aws_region
  aws_security_groupegress_all = var.aws_security_groupegress_all
  aws_vpc                      = var.aws_vpc
  aws_vpc_id                   = var.aws_vpc
  container_ingress            = var.sunrise_container_ingress
  container_port               = var.sunrise_container_port
  dns_zone_id                  = var.dns_zone_id
  dns_zone_value               = format("%s-%s.coast-test.%s", var.environment, var.aws_region, var.environment == "prod" ? "com" : "net")
  environment                  = var.environment
  private_d                    = var.private_subnet_d
  private_e                    = var.private_subnet_e
  public_d                     = var.public_subnet_d
  public_e                     = var.public_subnet_e
  web_ssl_cert_arn             = var.web_ssl_cert_arn
}
