module "networking" {
  source = "../mod/networking"
  // move to int when building for other envs
  // Export to use in sub deps
}

/*

module "ecs" {
  source             = "../mod/ecs"
  // move to int when building for other envs
  aws_security_groupegress_all = module.networking.aws_security_groupegress_all
  aws_security_grouphttp = module.networking.aws_security_grouphttp
  aws_security_grouphttps = module.networking.aws_security_grouphttps
  aws_security_groupingress_api = module.networking.aws_security_groupingress_api
  aws_vpc = module.networking.aws_vpc
  private_d = module.networking.private_d
  private_e = module.networking.private_e
  public_d = module.networking.public_d
  public_e = module.networking.public_e
  web_ssl_cert_arn = var.web_ssl_cert_arn
  depends_on = [module.networking]
}

*/

//TODO: Once done move towards OOP mods ( start stubbing out )



module "api" {
  source                        = "../mod/api"
  api_dns_value                 = format("%s-%s-api.coast-test.%s", var.environment, var.aws_region, var.environment == "prod" ? "com" : "net")
  api_image                     = "public.ecr.aws/u8j1b7o3/coast-test-go:latest"
  api_whitelist                 = var.api_whitelist
  aws_region                    = var.aws_region
  aws_vpc_id                    = module.networking.aws_vpc
  dns_zone_id                   = var.dns_zone_id
  dns_zone_value                = format("%s-%s.coast-test.%s", var.environment, var.aws_region, var.environment == "prod" ? "com" : "net")
  environment                   = var.environment
  web_ssl_cert_arn              = var.web_ssl_cert_arn
  aws_vpc                       = module.networking.aws_vpc
  private_d                     = module.networking.private_d
  private_e                     = module.networking.private_e
  public_d                      = module.networking.public_d
  public_e                      = module.networking.public_e
  aws_security_groupegress_all  = module.networking.aws_security_groupegress_all
  aws_security_groupingress_api = module.networking.aws_security_groupingress_api
  depends_on                    = [module.networking]
}
