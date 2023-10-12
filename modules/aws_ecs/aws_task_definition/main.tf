resource "aws_ecs_task_definition" "default" {
  family             = "${var.namespace}-ecs_task-definition-${var.environment}"
  execution_role_arn = var.ecs_task_execution_role_arn
  task_role_arn      = var.ecs_task_iam_role_arn

  container_definitions = jsonencode([
    {

      name      = var.service_name
      image     = "494250472911.dkr.ecr.us-east-1.amazonaws.com/movie-web-app:v.1"
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
          name : "DBNAME",
          value : "moviedb"
        },
        {
          name : "DBUSER",
          value : "stas"
        },
        {
          name : "DBHOST",
          value : "database.cgtbyvcjmrhg.us-east-1.rds.amazonaws.com"
        },
        {
          name : "DBSSLMODE",
          value : "none"
        },
        {
          name : "DBPORT",
          value : "3306"
        },
        {
          name : "DBPASS",
          value : "12345678"
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
