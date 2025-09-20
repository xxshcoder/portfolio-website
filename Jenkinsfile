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
                echo "Image pushed successfully: $DOCKER_IMAGE:$DOCKER_TAG"
            }
        }
        stage('Deploy to Minikube') {
            steps {
                script {
                    try {
                        // Check if kubectl is available and can connect
                        sh 'kubectl version --client'
                        sh 'kubectl cluster-info'
                        
                        // Apply Kubernetes manifests
                        sh 'kubectl apply -f deployment.yaml'
                        sh 'kubectl apply -f service.yaml'
                        
                        // Check rollout status
                        sh 'kubectl rollout status deployment/portfolio-deployment --timeout=300s'
                        
                        // Get service info
                        sh 'kubectl get services'
                        sh 'kubectl get pods'
                        
                        echo "Deployment to Minikube successful!"
                    } catch (Exception e) {
                        echo "Kubernetes deployment failed: ${e.getMessage()}"
                        echo "Image is still available at: $DOCKER_IMAGE:$DOCKER_TAG"
                        // Don't fail the entire pipeline
                        currentBuild.result = 'UNSTABLE'
                    }
                }
            }
        }
    }
    post {
        always {
            sh 'docker logout'
            sh 'docker system prune -f'
        }
        success {
            echo "Pipeline completed successfully!"
            echo "Application deployed to Minikube!"
            sh 'kubectl get pods -l app=portfolio-website || echo "No pods found"'
        }
    }
}
