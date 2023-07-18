output "alb_tg_arn" {
  value = aws_lb_target_group.api.*.arn
}

output "aws_security_groupegress_all" {
  value = aws_security_group.egress_all.id
}
output "aws_security_grouphttp" {
  value = aws_security_group.http.id
}
output "aws_security_grouphttps" {
  value = aws_security_group.https.id
}
output "aws_security_groupingress_api" {
  value = aws_security_group.ingress_api.id
}