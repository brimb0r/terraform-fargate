output "aws_security_groupegress_all" {
  value = module.networking.aws_security_groupegress_all
}
output "aws_security_grouphttp" {
  value = module.networking.aws_security_grouphttp
}
output "aws_security_grouphttps" {
  value = module.networking.aws_security_grouphttps
}
output "aws_vpc" {
  value = module.networking.aws_vpc
}
output "private_d" {
  value = module.networking.private_d
}
output "private_e" {
  value = module.networking.private_e
}
output "public_d" {
  value = module.networking.public_d
}
output "public_e" {
  value = module.networking.public_e
}