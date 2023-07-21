output "aws_security_groupegress_all" {
  value = module.vpc.aws_security_groupegress_all
}
output "aws_security_grouphttp" {
  value = module.vpc.aws_security_grouphttp
}
output "aws_security_grouphttps" {
  value = module.vpc.aws_security_grouphttps
}
output "aws_vpc" {
  value = module.vpc.aws_vpc
}
output "private_d" {
  value = module.vpc.private_d
}
output "private_e" {
  value = module.vpc.private_e
}
output "public_d" {
  value = module.vpc.public_d
}
output "public_e" {
  value = module.vpc.public_e
}