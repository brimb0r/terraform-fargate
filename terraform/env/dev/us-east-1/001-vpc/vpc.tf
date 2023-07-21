module "vpc" {
  source            = "../../../../inframod/networking"
  environment       = "dev"
  vpc_cidr_block    = "10.0.0.0/16"
  pub_d_cidr_block  = "10.0.1.0/25"
  priv_d_cidr_block = "10.0.2.0/25"
  pub_e_cidr_block  = "10.0.1.128/25"
  priv_e_cidr_block = "10.0.2.128/25"
}