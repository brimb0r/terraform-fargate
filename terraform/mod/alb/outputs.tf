output "alb_tg_arn" {
  value = aws_lb_target_group.tg.*.arn
}

output "alb_sec_group" {
  value = aws_security_group.lb_https.id
}