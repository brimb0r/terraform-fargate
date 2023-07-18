resource "aws_alb" "api" {
  name                             = var.lb_name
  internal                         = var.internal
  load_balancer_type = "application"

  enable_cross_zone_load_balancing = true
  idle_timeout                     = var.idle_timeout
  timeouts {
    create = "30m"
    delete = "30m"
  }

  subnets = [
    var.public_d,
    var.public_e,
  ]

  security_groups = [
    var.aws_security_grouphttp,
    var.aws_security_grouphttps,
    var.aws_security_groupegress_all,
  ]

  tags = {
    Environment = var.environment
    Service     = var.name
  }
  
}

resource "aws_security_group" "http" {
  name        = "http"
  description = "HTTP traffic"
  vpc_id      = var.aws_vpc

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "https" {
  name        = "https"
  description = "HTTPS traffic"
  vpc_id      = var.aws_vpc

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "egress_all" {
  name        = "egress-all"
  description = "Allow all outbound traffic"
  vpc_id      = var.aws_vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress_api" {
  name        = "ingress-api"
  description = "Allow ingress to API"
  vpc_id      = var.aws_vpc

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "api" {
  name        = "api"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.aws_vpc

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.api]
}


resource "aws_alb_listener" "api_http" {
  load_balancer_arn = aws_alb.api.arn
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

variable "web_ssl_cert_arn" {}

resource "aws_alb_listener" "api_https" {
  load_balancer_arn = aws_alb.api.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.web_ssl_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
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
