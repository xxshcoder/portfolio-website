pipeline {
    agent none // Run on the default Jenkins node

    environment {
        DOCKER_IMAGE = "xxshcoder/portfolio-website"
        DOCKER_CONFIG = "${WORKSPACE}/.docker" // Ensure Docker config is in a writable directory
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/xxshcoder/portfolio-website.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'mkdir -p ${WORKSPACE}/.docker'
                sh 'docker build -t $DOCKER_IMAGE:latest .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh 'docker push $DOCKER_IMAGE:latest'
            }
        }
    }

    post {
        always {
            sh 'docker logout' // Log out of Docker Hub to avoid storing credentials
            sh 'docker system prune -f' // Clean up unused Docker images and containers
        }
    }
}
