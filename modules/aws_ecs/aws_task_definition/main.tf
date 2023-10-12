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
          name : "DBNAME",
          value : "test"
        },
        {
          name : "DBUSER",
          value : "test"
        },
        {
          name : "DBHOST",
          value : "aws_db_instance.rds_db.endpoint"
        },
        {
          name : "DBSSLMODE",
          value : "none"
        },
        {
          name : "DBPORT",
          value : "test"
        },
        {
          name : "DBPASS",
          value : "test"
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
