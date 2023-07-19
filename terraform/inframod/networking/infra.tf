module "networking" {
  source            = "../../mod/networking"
  priv_d_cidr_block = var.priv_d_cidr_block
  priv_e_cidr_block = var.priv_e_cidr_block
  pub_d_cidr_block  = var.pub_d_cidr_block
  pub_e_cidr_block  = var.pub_e_cidr_block
  vpc_cidr_block    = var.vpc_cidr_block
}
