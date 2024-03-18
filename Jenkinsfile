pipeline {
    agent any
    environment {
        // Define static environment variables
        AWS_ACCOUNT_ID = '099199746132'
        AWS_DEFAULT_REGION = 'eu-west-1'
        ECR_REPOSITORY = 'angular-app-ecr'
        ECS_CLUSTER_NAME = 'Demo-Node-App-Cluster'
        ECS_SERVICE_NAME = 'angular-service'
    }
    stages {
        stage('Prepare') {
            steps {
                script {
                    // Use Groovy's 'sh' step to execute shell commands and capture the output
                    // Use Git to get the short SHA of the last commit
                    def shortSha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    // Set the IMAGE_TAG environment variable to 'latest' and append the short SHA
                    env.IMAGE_TAG = "latest,${shortSha}"
                    echo "IMAGE_TAG is set to ${env.IMAGE_TAG}"
                }
            }
        }
        stage('Checkout Code') {
            steps {
                checkout scm: [
                    $class: 'GitSCM',
                    branches: [[name: '*/main']], // Adjust branch as needed
                    userRemoteConfigs: [[
                        credentialsId: 'GitHub-PAT',
                        url: 'https://github.com/jawadsaeed126/hello-world-angular.git'
                    ]]
                ]
            }
        }
        stage('Login to ECR') {
            steps {
                script {
                    // Login to ECR
                    sh "aws ecr get-login-password --region ${env.AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_DEFAULT_REGION}.amazonaws.com"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image with the dynamically set tag
                    sh "docker build -t ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_DEFAULT_REGION}.amazonaws.com/${env.ECR_REPOSITORY}:${env.IMAGE_TAG} ."
                }
            }
        }
        
        stage('Push Docker Image to ECR') {
            steps {
                script {
                    // Push the Docker image to the ECR repository
                    sh "docker push ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_DEFAULT_REGION}.amazonaws.com/${env.ECR_REPOSITORY}:${env.IMAGE_TAG}"
                }
            }
        }
        stage('Deploy to ECS') {
            steps {
                script {
                    // Update the ECS service to use the new Docker image
                    sh "aws ecs update-service --cluster ${env.ECS_CLUSTER_NAME} --service ${env.ECS_SERVICE_NAME} --force-new-deployment"
                }
            }
        }
    }
    post {
        always {
            // Added a simple echo step to ensure the block is not empty
            echo 'Cleanup or notification steps can be added here.'
        }
    }
}
