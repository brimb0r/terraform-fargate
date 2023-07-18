resource "aws_iam_role" "api_instance_region_role" {
  name               = "${var.environment}_${var.aws_region}_api_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_instance_profile" "api_region_role" {
  name = "${var.environment}_${var.aws_region}_api_profile"
  role = aws_iam_role.api_instance_region_role.name
}

resource "aws_iam_policy" "can_read_api_parameters" {
  name        = "${var.environment}_${var.aws_region}_api_read_param_store"
  path        = "/"
  description = "additional permissions for api fargate containers"
  policy      = data.aws_iam_policy_document.can_read_api_parameters.json
}

resource "aws_iam_policy" "api_instance_perms" {
  name        = "${var.environment}_${var.aws_region}_api_perms"
  path        = "/"
  description = "Caution: Every container gets these permissions including support "
  policy      = data.aws_iam_policy_document.all_instance_perms.json
}

resource "aws_iam_role_policy_attachment" "api_instance_perms_to_api_instance_region" {
  role       = aws_iam_role.api_instance_region_role.name
  policy_arn = aws_iam_policy.api_instance_perms.arn
}

resource "aws_iam_role_policy_attachment" "api_instance_role_can_read_auth_parameters" {
  role       = aws_iam_role.api_instance_region_role.name
  policy_arn = aws_iam_policy.can_read_api_parameters.arn
}

data "aws_iam_policy_document" "can_read_api_parameters" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]
    resources = ["*"]
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "ssm:resourceTag/Service"
      values   = ["*api*"]
    }
    condition {
      test     = "StringEqualsIgnoreCase"
      variable = "ssm:resourceTag/Environment"
      values   = [var.environment]
    }
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "all_instance_perms" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]
    resources = ["arn:aws:logs:*"]
  }

  statement {
    actions = [
      "s3:Get*",
      "s3:*"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:sqs::*-${var.environment}",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeTags",
      "ec2:DescribeInstances",
      "ec2:DescribeImages",
      "cloudwatch:PutMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "cloudwatch:PutMetricAlarm",
      "sns:ListTopics",
      "ec2:CreateTags",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses",
      "ec2:DescribeInstanceStatus",
      "ec2:AttachVolume",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumeStatus",
      "elasticfilesystem:DescribeFileSystems",
      "sqs:*"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "autoscaling:*"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeParameters"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]
    resources = [
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/env.${var.environment}/*"
    ]
  }

}