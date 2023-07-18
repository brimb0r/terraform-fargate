

# We need a cluster in which to put our service.
resource "aws_ecs_cluster" "app" {
  name = "app"
}

# An ECR repository is a private alternative to Docker Hub.
resource "aws_ecr_repository" "api" {
  name = "api"
}

# Log groups hold logs from our app.
resource "aws_cloudwatch_log_group" "api" {
  name = "/ecs/api"
}

# The main service.

resource "aws_ecs_service" "api" {
  name            = "api"
  task_definition = aws_ecs_task_definition.api.arn
  cluster         = aws_ecs_cluster.app.id
  launch_type     = "FARGATE"

  desired_count = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = "api"
    container_port   = "3000"
  }

  network_configuration {
    assign_public_ip = false

    security_groups = [
      var.aws_security_groupegress_all,
      var.aws_security_groupingress_api,
    ]

    subnets = [
      var.private_d,
      var.private_e,
    ]
  }
}

# The task definition for our app.
resource "aws_ecs_task_definition" "api" {
  family = "api"

  container_definitions = <<EOF
  [
    {
      "name": "api",
      "image": "public.ecr.aws/u8j1b7o3/coast-test-go:latest",
      "portMappings": [
        {
          "containerPort": 3000
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "us-east-1",
          "awslogs-group": "/ecs/api",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]

EOF

  execution_role_arn = aws_iam_role.api_task_execution_role.arn

  # These are the minimum values for Fargate containers.
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]

  # This is required for Fargate containers (more on this later).
  network_mode = "awsvpc"
}

# This is the role under which ECS will execute our task. This role becomes more important
# as we add integrations with other AWS services later on.

# The assume_role_policy field works with the following aws_iam_policy_document to allow
# ECS tasks to assume this role we're creating.
resource "aws_iam_role" "api_task_execution_role" {
  name               = "api-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Normally we'd prefer not to hardcode an ARN in our Terraform, but since this is an AWS-managed
# policy, it's okay.
data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach the above policy to the execution role.
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.api_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
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

resource "aws_alb" "api" {
  name               = "api-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    var.public_d,
    var.public_e,
  ]

  security_groups = [
    var.aws_security_grouphttp,
    var.aws_security_grouphttps,
    var.aws_security_groupegress_all,
  ]
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

output "alb_url" {
  value = "http://${aws_alb.api.dns_name}"
}
