module "state" {
  source            = "../../../mod/state"
  aws_bucket_region = var.aws_region
  is_prod           = "false"
}
