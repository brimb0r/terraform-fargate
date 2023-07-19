output "aws_security_groupegress_all" {
  value = aws_security_group.egress_all.id
}
output "aws_security_grouphttp" {
  value = aws_security_group.http.id
}
output "aws_security_grouphttps" {
  value = aws_security_group.https.id
}
output "aws_vpc" {
  value = aws_vpc.app_vpc.id
}
output "private_d" {
  value = aws_subnet.private_d.id
}
output "private_e" {
  value = aws_subnet.private_e.id
}
output "public_d" {
  value = aws_subnet.public_d.id
}
output "public_e" {
  value = aws_subnet.public_e.id
}