pipeline {
    environment {
        AWS_ACCOUNT_ID = '099199746132'
        AWS_DEFAULT_REGION = 'eu-west-1'
        ECR_REPOSITORY = 'angular-app-ecr'
        ECS_CLUSTER_NAME = 'Demo-Node-App-Cluster'
        ECS_SERVICE_NAME = 'angular-service-app'
    }
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Check out your source code here
                checkout scm
            }
        }

        stage('Build and Tag Docker Image') {
            steps {
                script {
                    // Get the short Git commit hash to use as a tag
                    GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    IMAGE_TAG = "${ECR_REPOSITORY}:${GIT_COMMIT}"

                    // Build the Docker image
                    sh "docker build -t ${IMAGE_TAG} ."
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    // Login to Amazon ECR
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY}"

                    // Push the image to ECR
                    sh "docker push ${IMAGE_TAG}"

                    // Optionally, update the ECS service to use the new image, if desired
                      sh "aws ecs update-service --cluster ${ECS_CLUSTER_NAME} --service ${ECS_SERVICE_NAME} --force-new-deployment --region ${AWS_REGION}"
                }
            }
        }

        // Include additional stages as needed
        
    }

    post {
        always {
            // Cleanup, notifications, etc.
            echo 'Build completed'
        }
    }
}
