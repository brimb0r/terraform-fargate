module "sunrise_api" {
  source                    = "../../../../../inframod/ecs-api"
  aws_region                = "us-east-1"
  dns_zone_id               = "Z029066226EQ52O1INONO"
  environment               = "dev"
  web_ssl_cert_arn          = "arn:aws:acm:us-east-1:826238445673:certificate/d577b734-a901-483e-9379-1f6fbcd5445f"
  sunrise_container_ingress = [3000, 3000, "tcp", "LB Can hit this"]
  sunrise_container_port    = 3000
  api_whitelist = [
    "0.0.0.0/0",
  ]
}