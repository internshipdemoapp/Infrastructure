variable "region" {
  default = "us-east-1"
}

variable "namespace" {
  description = "Namespace for resource names"
  type        = string
}

variable "environment" {
  description = "Environment for deployment"
  default     = "staging"
  type        = string
}

variable "service_name" {
  description = "A Docker image-compatible name for the service"
  type        = string
  default     = "Store-Web-Application"
}

# variable "" {
  
# }

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_task_iam_role_arn" {
  type = string
}

variable "container_port" {
  description = "Port of the container"
  type        = number
  default     = 80
}

variable "cpu_units" {
  description = "Amount of CPU units for a single ECS task"
  default     = 100
  type        = number
}

variable "memory" {
  description = "Amount of memory in MB for a single ECS task"
  default     = 256
  type        = number
}

variable "log_group_name" {
  type = string
}

variable "secretsmanager_secret_db_arn" {
  type = string
}

