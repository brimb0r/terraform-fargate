module "sunrise_api" {
  source                    = "../../../../../inframod/sunrise-ecs-api"
  aws_region                = "us-east-1"
  dns_zone_id               = "Z029066226EQ52O1INONO"
  environment               = "dev"
  web_ssl_cert_arn          = "arn:aws:acm:us-east-1:826238445673:certificate/d577b734-a901-483e-9379-1f6fbcd5445f"
  sunrise_container_ingress = [3000, 3000, "tcp", "LB Can hit this"]
  sunrise_container_port    = 3000
  api_whitelist = [
    "0.0.0.0/0",
  ]
  aws_security_groupegress_all = data.terraform_remote_state.vpc.outputs.aws_security_groupegress_all
  aws_vpc                      = data.terraform_remote_state.vpc.outputs.aws_vpc
  private_subnet_d             = data.terraform_remote_state.vpc.outputs.private_d
  private_subnet_e             = data.terraform_remote_state.vpc.outputs.private_e
  public_subnet_d              = data.terraform_remote_state.vpc.outputs.public_d
  public_subnet_e              = data.terraform_remote_state.vpc.outputs.public_e
}