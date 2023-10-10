resource "aws_ecr_repository" "ecr_repo" {
  name = "app-repo"
  force_delete = true
  
}
