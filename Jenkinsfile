pipeline {
    agent {
        docker {
            image 'docker:24.0.2'
            args '-v /var/run/docker.sock:/var/run/docker.sock --group-add 999'
        }
    }

    environment {
        DOCKER_IMAGE = "xxshcoder/portfolio-website"
        DOCKER_CONFIG = "${WORKSPACE}/.docker"
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

        stage('Deploy to Minikube') {
            steps {
                // Set Minikube environment if using local Docker daemon
                // sh 'eval $(minikube docker-env)'

                // Pull image inside Minikube (if not using Minikube Docker)
                sh 'kubectl delete pod portfolio-app --ignore-not-found'
                sh 'kubectl run portfolio-app --image=$DOCKER_IMAGE:latest --port=8080 --restart=Never'
                sh 'kubectl expose pod portfolio-app --type=NodePort --port=8080 || true'
                sh 'minikube service portfolio-app --url'
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
