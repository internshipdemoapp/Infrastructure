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
                sh ('terraform plan -target="module.aws_cloud_watch_logs"') 
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
                sh ('terraform plan -target="module.aws_ecs_cluster"') 
                sh ('terraform plan -target="module.aws_ecs_task_defenition"') 
                sh ('terraform plan -target="module.aws_ecs_service"') 
                sh ('terraform plan -target="module.aws_launch_template"') 
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
                
                echo "ECR Authentication.."
                sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 203203060972.dkr.ecr.us-east-1.amazonaws.com"
                
            }
        }    

        stage('Build&Tag') {
            steps {  
                echo "Pushing to ECR..."
                sh 'cd Store-Web-Application'
                sh 'docker build -f MVC_apple_store/Dockerfile -t store-web-application .'
                sh 'docker tag store-web-application:latest 203203060972.dkr.ecr.us-east-1.amazonaws.com/store-web-application:latest' 
            }
        }
        stage("Pushing to ECR"){
            steps{
                echo "Pushing to ECR..."
                sh "docker push 203203060972.dkr.ecr.us-east-1.amazonaws.com/store-web-application:latest"
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