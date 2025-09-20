pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "xxshcoder/portfolio-website"
        DOCKER_TAG   = "latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/xxshcoder/portfolio-website.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push $DOCKER_IMAGE:$DOCKER_TAG'
            }
        }

        stage('Deploy to Minikube') {
            steps {
                // Ensure Minikube is running
                sh 'minikube start'

                // Apply your existing deployment and service YAML files
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'

                // Optional: check rollout status
                sh 'kubectl rollout status deployment/portfolio-deployment'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
            sh 'docker system prune -f'
        }
    }
}
