resource "aws_security_group" "lb_http" {
  name        = format("%s_%s_http_lb_sg", var.environment, var.name)
  vpc_id      = var.vpc_id
  description = format("load balancer sg for http for env:%s lb:%s", var.environment, var.name)
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group" "lb_https" {
  name        = format("%s_%s_https_lb_sg", var.environment, var.name)
  vpc_id      = var.vpc_id
  description = format("load balancer sg for https for env:%s lb:%s", var.environment, var.name)

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.internal_cidr]
  }

  lifecycle { create_before_destroy = true }
}

resource "aws_security_group" "lb_http2" {
  name        = format("%s_%s_http_lb_sg2", var.environment, var.name)
  vpc_id      = var.vpc_id
  description = format("second load balancer sg for http for env:%s lb:%s", var.environment, var.name)
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group" "lb_https2" {
  name        = format("%s_%s_https_lb_sg2", var.environment, var.name)
  vpc_id      = var.vpc_id
  description = format("second load balancer sg for https for env:%s lb:%s", var.environment, var.name)

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.internal_cidr]
  }

  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "ingress_rules_http" {
  count = length(var.ingress_rules_http)

  security_group_id = aws_security_group.lb_http.id
  type              = "ingress"
  cidr_blocks       = var.ingress_whitelist

  from_port   = var.ingress_rules_http[count.index][0]
  to_port     = var.ingress_rules_http[count.index][1]
  protocol    = var.ingress_rules_http[count.index][2]
  description = var.ingress_rules_http[count.index][3]
  //  lifecycle { create_before_destroy = true } // Need newest version of TF for this to work
  depends_on = [
    aws_security_group_rule.ingress_rules_http2,
    aws_security_group_rule.ingress_rules_https2
  ]
}

resource "aws_security_group_rule" "ingress_rules_https" {
  count = length(var.ingress_rules_https)

  security_group_id = aws_security_group.lb_https.id
  type              = "ingress"
  cidr_blocks       = var.ingress_whitelist

  from_port   = var.ingress_rules_https[count.index][0]
  to_port     = var.ingress_rules_https[count.index][1]
  protocol    = var.ingress_rules_https[count.index][2]
  description = var.ingress_rules_https[count.index][3]
  //  lifecycle { create_before_destroy = true } // Need newest version of TF for this to work
  depends_on = [
    aws_security_group_rule.ingress_rules_http2,
    aws_security_group_rule.ingress_rules_https2
  ]
}

resource "aws_security_group_rule" "ingress_rules_http2" {
  count = length(var.ingress_rules_http)

  security_group_id = aws_security_group.lb_http2.id
  type              = "ingress"
  cidr_blocks       = var.ingress_whitelist

  from_port   = var.ingress_rules_http[count.index][0]
  to_port     = var.ingress_rules_http[count.index][1]
  protocol    = var.ingress_rules_http[count.index][2]
  description = var.ingress_rules_http[count.index][3]
  //  lifecycle { create_before_destroy = true } // Need newest version of TF for this to work
}

resource "aws_security_group_rule" "ingress_rules_https2" {
  count = length(var.ingress_rules_https)

  security_group_id = aws_security_group.lb_https2.id
  type              = "ingress"
  cidr_blocks       = var.ingress_whitelist

  from_port   = var.ingress_rules_https[count.index][0]
  to_port     = var.ingress_rules_https[count.index][1]
  protocol    = var.ingress_rules_https[count.index][2]
  description = var.ingress_rules_https[count.index][3]
  //  lifecycle { create_before_destroy = true } // Need newest version of TF for this to work
}

resource "aws_lb" "lb" {
  name                             = var.lb_name
  subnets                          = var.subnet_ids
  security_groups                  = [aws_security_group.lb_http.id, aws_security_group.lb_https.id, aws_security_group.lb_http2.id, aws_security_group.lb_https2.id]
  internal                         = var.internal
  enable_cross_zone_load_balancing = true
  idle_timeout                     = var.idle_timeout
  timeouts {
    create = "30m"
    delete = "30m"
  }

  tags = {
    Environment = var.environment
    Service     = var.name
  }
}

resource "aws_lb_target_group" "tg" {
  count      = length(var.listener_targets)
  depends_on = [aws_lb.lb]

  name        = format("fgate-tg-%s-%s-%s", var.name, var.environment, count.index)
  port        = var.listener_targets[count.index]["be_port"]
  protocol    = var.listener_targets[count.index]["be_proto"]
  vpc_id      = var.vpc_id
  target_type = "ip"

  dynamic "health_check" {
    for_each = [lookup(var.listener_targets[count.index], "health_check", {})]
    content {
      enabled             = lookup(health_check.value, "enabled", var.health_check_enabled)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", var.health_check_healthy_threshold)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", var.health_check_unhealthy_threshold)
      interval            = lookup(health_check.value, "interval", var.health_check_interval)
      timeout             = lookup(health_check.value, "timeout", var.health_check_timeout)
      matcher             = lookup(health_check.value, "matcher", var.health_check_matcher)
      port                = lookup(health_check.value, "port", var.health_check_port)
      path                = lookup(health_check.value, "path", var.health_check_path)
      protocol            = lookup(health_check.value, "protocol", var.listener_targets[count.index]["be_proto"])
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "lb_listener" {
  count = length(var.listener_targets)

  load_balancer_arn = aws_lb.lb.arn
  port              = var.listener_targets[count.index]["lb_port"]
  protocol          = var.listener_targets[count.index]["lb_proto"]

  ssl_policy      = var.listener_targets[count.index]["lb_proto"] == "HTTPS" ? "ELBSecurityPolicy-TLS-1-2-Ext-2018-06" : null
  certificate_arn = var.listener_targets[count.index]["lb_proto"] == "HTTPS" ? var.web_ssl_cert_arn : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[count.index].arn
  }
}

resource "aws_lb_listener" "lb_redirect_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_route53_record" "dns_name" {
  zone_id = var.dns_zone_id
  name    = var.dns_zone_value
  type    = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
  }
}
