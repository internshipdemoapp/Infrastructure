data "aws_secretsmanager_secret_version" "creds" {
  secret_id = var.secret_name
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

resource "aws_ecs_task_definition" "default" {
  family             = "${var.namespace}-ecs-task-definition-${var.environment}"
  execution_role_arn = var.ecs_task_execution_role_arn
  task_role_arn      = var.ecs_task_iam_role_arn

  container_definitions = jsonencode([
    {
      name      = var.service_name
      image     = "494250472911.dkr.ecr.us-east-1.amazonaws.com/store-web-application:latest"
      cpu       = var.cpu_units
      memory    = var.memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      environment : [
        {
          name : "DbName",
          value : local.db_creds.DbName
        },
        {
          name : "DbUsername",
          value : local.db_creds.DbUsername
        },
        {
          name : "DbHost",
          value : var.db_host
        },
        {
          name : "DbPassword",
          value : local.db_creds.DbPassword
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = var.log_group_name,
          "awslogs-region"        = var.region,
          "awslogs-stream-prefix" = "app"
        }
      }
    }
  ])
}
