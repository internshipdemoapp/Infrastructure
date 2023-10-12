pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
    
        stage ("Terraform init") {
            steps {
                echo "Terraform init..."
                sh ("terraform init ") 
            }
        }
        stage ("Logs module plan") {
            steps {
                echo "Logs module plan..."
                sh ('terraform plan -target="module.aws_ecr"') 
            }
        }

        stage ("Network module plan") {
            steps {
                echo "Network module plan..."
                sh ('terraform plan -target="module.aws_vpc"') 
                sh ('terraform plan -target="module.aws_subnets"')
                sh ('terraform plan -target="module.aws_sg')
                sh ('terraform plan -target="module.aws_alb"')
                sh ('terraform plan -target="module.aws_dns"')
            }
        }

        stage ("DB module plan") {
            steps {
                echo "DB module plan..."
                sh ('terraform plan -target="module.aws_db"') 
            }
        }

        stage ("EC2 module plan") {
            steps {
                echo "Pushing to ECR..."
                sh ('terraform plan -target="module.aws_bastion_host"') 
                
            }
        }

        stage ("ECR module plan") {
            steps {
                echo "ECR module plan..."
                sh ('terraform plan -target="module.aws_ecr"') 
            }
        }

        stage ("ECS module plan") {
            steps {
                echo "ECS module plan..."
                sh ('terraform plan -target="aws_ecs_cluster"') 
                sh ('terraform plan -target="aws_ecs_task_defenition"') 
                sh ('terraform plan -target="aws_ecs_service"') 
                sh ('terraform plan -target="aws_launch_template"') 
            }
        }

        stage ("IAM module plan") {
            steps {
                echo "IAM module plan..."
                sh ('terraform plan -target="module.aws_iam"') 
            }
        }    

        stage("ECR Authentication"){
            steps{
                
                echo "Logging to ECR.."
                sh ""
                
            }
        }    

        stage('Build&Tag') {
            steps {  
                echo "Pushing to ECR..."         
                sh 'docker build -f MVC_apple_store/Dockerfile .'
                sh 'cd MVC_apple_store'
                sh 'docker tag ' 
            }
        }
        stage("Pushing to ECR"){
            steps{
                echo "Pushing to ECR..."
                sh ""
            }
        }
        stage('Update ECS'){
            steps{
                echo "Update ECS..."
                sh 'aws ecs update-service --region us-east-1 --cluster app-cluster --service demo-2-service --force-new-deployment'
            }
        }

}
}