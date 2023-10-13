data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

# data "aws_key_pair" "ssh" {
#   key_name = var.key_pair_name
# }

resource "aws_launch_template" "ecs_launch_template" {
  name          = "${var.namespace}-ecs-launch-template-${var.environment}"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  # key_name               = data.aws_key_pair.ssh.id
  user_data              = base64encode(data.template_file.user_data.rendered)
  vpc_security_group_ids = [var.security_group_ec2_id]

  iam_instance_profile {
    arn = var.ec2_instance_role_profile_arn
  }

  monitoring {
    enabled = true
  }
}

data "template_file" "user_data" {
  template = file("user_data.sh")

  vars = {
    ecs_cluster_name = var.ecs_cluster_name
  }
}
