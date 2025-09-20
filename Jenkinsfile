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
                        sh 'kubectl rollout status deployment/portfolio-website --timeout=300s'
                        
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
        stage('Expose Service URL') {
            steps {
                script {
                    try {
                        // Get the service URL
                        def serviceUrl = sh(
                            script: 'minikube service portfolio-website-service --url',
                            returnStdout: true
                        ).trim()
                        
                        echo "================================================================"
                        echo "🚀 DEPLOYMENT SUCCESSFUL!"
                        echo "================================================================"
                        echo "Your portfolio website is now accessible at:"
                        echo "📍 URL: ${serviceUrl}"
                        echo "================================================================"
                        echo "You can access your application by opening the above URL in your browser."
                        
                        // Also show kubectl port-forward alternative
                        echo ""
                        echo "Alternative access methods:"
                        echo "1. Direct URL: ${serviceUrl}"
                        echo "2. Port forward: kubectl port-forward service/portfolio-website-service 8080:80"
                        echo "   Then access at: http://localhost:8080"
                        
                        // Test if the service is responding
                        sh "curl -s -o /dev/null -w 'HTTP Status: %{http_code}' ${serviceUrl} || echo 'Service check failed'"
                        
                    } catch (Exception e) {
                        echo "Could not get service URL: ${e.getMessage()}"
                        echo "You can manually get the URL with: minikube service portfolio-website-service --url"
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
