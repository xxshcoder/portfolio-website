pipeline {
    agent {
        docker {
            image 'docker:24.0.2'
            args '-v /var/run/docker.sock:/var/run/docker.sock --group-add 999' // Replace 999 with the host's docker group GID
        }
    }

    environment {
        DOCKER_IMAGE = "xxshcoder/portfolio-website"
        DOCKER_CONFIG = "${WORKSPACE}/.docker" // Avoid permission issues with /.docker
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
