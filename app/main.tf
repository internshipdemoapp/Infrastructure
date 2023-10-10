provider "aws" {
  region = var.region
}
module "aws_ecs_cluster" {
  source    = "../modules/aws_ecs/aws_cluster"
  namespace = var.namespace
}

module "aws_ecs_task_defenition" {
  source    = "../modules/aws_ecs/aws_task_definition"
  namespace = var.namespace
  secretsmanager_secret_db_arn =  module.aws_db.secretsmanager_secret_db_arn
  log_group_name = module.aws_cloud_watch_logs.log_group_name
  ecs_task_execution_role_arn = module.aws_iam.ecs_task_execution_role_arn
  ecs_task_iam_role_arn = module.aws_iam.ecs_task_iam_role_arn
}

module "aws_ecs_service" {
  source                   = "../modules/aws_ecs/aws_service"
  namespace                = var.namespace
  ecs_cluster_default_name = module.aws_ecs_cluster.ecs_cluster_name
  ecs_cluster_id = module.aws_ecs_cluster.ecs_cluster_id
  ecs_service_role_arn = module.aws_iam.ecs_service_role_arn
  service_target_group_arn = module.aws_alb.service_target_group_arn
  task_definition_arn = module.aws_ecs_task_defenition.task_definition_arn
}

module "aws_launch_template" {
  source    = "../modules/aws_ecs/aws_launch_template"
  namespace = var.namespace
  ecs_cluster_name = module.aws_ecs_cluster.ecs_cluster_name
  security_group_ec2_id = module.aws_sg.security_group_ec2_id
  ec2_instance_role_profile_arn = module.aws_iam.ec2_instance_role_profile_arn
}