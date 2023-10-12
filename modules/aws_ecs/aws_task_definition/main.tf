data "aws_secretsmanager_secret_version" "creds" {
  secret_id = var.secret_name
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

resource "aws_ecs_task_definition" "default" {
  family             = "${var.namespace}-ecs_task-definition-${var.environment}"
  execution_role_arn = var.ecs_task_execution_role_arn
  task_role_arn      = var.ecs_task_iam_role_arn

  container_definitions = jsonencode([
    {

      name      = var.service_name
      image     = "test"
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
          name : "DbPassword",
          value : local.db_creds.DbPassword
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
