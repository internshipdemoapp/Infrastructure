data "aws_secretsmanager_secret_version" "creds" {
  secret_id = var.secret_name
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  description = "RDS Security Group"
  vpc_id      = data.aws_vpc.default.id
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds_db" {
  allocated_storage    = 15
  identifier           = "apple-store-db"
  db_name              = local.db_creds.DbName
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       =  var.instance_class
  username             = local.db_creds.DbUsername
  password             = local.db_creds.DbPassword

  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot  = true
  publicly_accessible =  true
}