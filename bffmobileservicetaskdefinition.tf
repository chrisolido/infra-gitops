data "aws_iam_policy_document" "ecs_task_execution_role-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "instance_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role-assume-role-policy.json

  inline_policy {
    name = "ecs_task_execution_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "secretsmanager:GetSecretValue",
            "kms:Decrypt",
            "ssm:GetParameters",
            "ssm:GetParameter"
            ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

## IAM Role
#resource "aws_iam_role" "ecs_task_execution_role" {
#  name = "ecs_task_execution"
#
#  # Terraform's "jsonencode" function converts a
#  # Terraform expression result to valid JSON syntax.
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = "sts:AssumeRole"
#        Effect = "Allow"
#        Sid    = ""
#        Principal = {
#          Service = "ecs-tasks.amazonaws.com"
#        }
#      },
#    ]
#  })
#
#  tags = {
#    Environment = "Development ecs_task_execution_role mobile-bff"
#  }
#}

# IAM Role
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Environment = "Development ecs_task_role mobile-bff"
  }
}
resource "aws_ecs_task_definition" "bffMobileService" {
  family                   = "bffMobileService"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]
  container_definitions = <<TASK_DEFINITION
[
  {
    "cpu": 10,
    "command": ["sleep", "10"],
    "entryPoint": ["/"],
    "environment": [
      {"name": "DB_HOST", "value": "sample.postgres.db"},
      {"name": "DB_NAME", "value": "bff-database"}
    ],
    "essential": true,
    "image": "jenkins",
    "memory": 128,
    "name": "jenkins",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
TASK_DEFINITION

#  proxy_configuration {
#    type           = "APPMESH"
#    container_name = "bffmobile"
#    properties = {
#      AppPorts         = "3000"
#      EgressIgnoredIPs = "169.254.170.2,169.254.169.254"
#      IgnoredUID       = "1337"
#      ProxyEgressPort  = 3000
#      ProxyIngressPort = 3000
#    }
#  }
}