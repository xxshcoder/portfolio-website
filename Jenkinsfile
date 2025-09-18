pipeline {
    agent {
        docker {
            image 'docker:24.0.7' // Docker image with Docker CLI
            args '-v /var/run/docker.sock:/var/run/docker.sock --user root' // Mount Docker socket and run as root to avoid permission issues
        }
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds') // Docker Hub credentials
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
                sh 'docker build -t ${DOCKER_IMAGE}:v3-jenkins-pushed .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
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
            sh 'docker logout' // Log out from Docker Hub to avoid credential leaks
        }
    }
}
