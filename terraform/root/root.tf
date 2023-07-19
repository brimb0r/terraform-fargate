module "networking" {
  source            = "../mod/networking"
  priv_d_cidr_block = var.priv_d_cidr_block
  priv_e_cidr_block = var.priv_e_cidr_block
  pub_d_cidr_block  = var.pub_d_cidr_block
  pub_e_cidr_block  = var.pub_e_cidr_block
  vpc_cidr_block    = var.vpc_cidr_block
}

module "api" {
  source                       = "../mod/api"
  api_dns_value                = format("%s-%s-api.coast-test.%s", var.environment, var.aws_region, var.environment == "prod" ? "com" : "net")
  api_image                    = "public.ecr.aws/u8j1b7o3/coast-test-go:latest"
  api_whitelist                = var.api_whitelist
  aws_region                   = var.aws_region
  aws_security_groupegress_all = module.networking.aws_security_groupegress_all
  aws_vpc                      = module.networking.aws_vpc
  aws_vpc_id                   = module.networking.aws_vpc
  container_ingress            = var.sunrise_container_ingress
  container_port               = var.sunrise_container_port
  dns_zone_id                  = var.dns_zone_id
  dns_zone_value               = format("%s-%s.coast-test.%s", var.environment, var.aws_region, var.environment == "prod" ? "com" : "net")
  environment                  = var.environment
  private_d                    = module.networking.private_d
  private_e                    = module.networking.private_e
  public_d                     = module.networking.public_d
  public_e                     = module.networking.public_e
  web_ssl_cert_arn             = var.web_ssl_cert_arn
  depends_on                   = [module.networking]
}
