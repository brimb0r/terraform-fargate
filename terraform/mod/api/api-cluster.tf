resource "aws_ecs_cluster" "api" {
  name = format("api-%s-%s", var.environment, var.aws_region)

  tags = {
    Environment = var.environment
  }
}

resource "aws_ecs_service" "api" {
  name            = format("api-%s-%s", var.environment, var.aws_region)
  cluster         = aws_ecs_cluster.api.name
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = module.api-lb-primary.alb_tg_arn[0]
    container_name   = "api"
    container_port   = var.container_port
  }

  network_configuration {
    assign_public_ip = false

    security_groups = [
      var.aws_security_groupegress_all,
      aws_security_group.ingress_api.id,
    ]

    subnets = [
      var.private_d,
      var.private_e,
    ]
  }
}



resource "aws_ecs_task_definition" "api" {
  family                   = "api"
  container_definitions    = data.template_file.api.rendered
  execution_role_arn       = aws_iam_role.api_instance_region_role.arn
  task_role_arn            = aws_iam_role.api_instance_region_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  tags = {
    Environment = var.environment
  }
}

data "template_file" "api" {
  template = file("${path.module}/task-defs/base.json")
  vars = {
    api_name       = "api"
    api_image      = var.api_image
    region         = var.aws_region
    environment    = var.environment
    api_flags      = "-fargate -environment ${var.environment} -region ${var.aws_region}"
    api_logs_group = aws_cloudwatch_log_group.api.name
    container_port = var.container_port
  }
}

resource "aws_cloudwatch_log_group" "api" {
  name = "/aws/fargate/${aws_ecs_cluster.api.name}/api"

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group" "ingress_api" {
  name        = format("ingress-api-%s-%s", var.environment, var.aws_region)
  description = "Allow ingress to API"
  vpc_id      = var.aws_vpc

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}