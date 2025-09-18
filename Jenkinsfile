pipeline {
    agent any  // Run on the default Jenkins node (with host Docker mounted)

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        DOCKER_IMAGE = "xxshcoder/portfolio-website"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/xxshcoder/portfolio-website.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build Docker image using host Docker
                sh 'docker build -t ${DOCKER_IMAGE}:v3-jenkins-pushed .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                // Login using stored credentials
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh 'docker push ${DOCKER_IMAGE}:v3-jenkins-pushed'
            }
        }
    }

    post {
        always {
            // Logout Docker to avoid leaving credentials
            sh 'docker logout || true'
        }
    }
}
