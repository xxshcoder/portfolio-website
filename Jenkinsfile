pipeline {
    agent any

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
            agent {
                docker {
                    image 'docker:24.0.2'
                    args '-v /var/run/docker.sock:/var/run/docker.sock --group-add 999'
                }
            }
            steps {
                sh 'mkdir -p ${WORKSPACE}/.docker'
                sh 'docker build -t $DOCKER_IMAGE:latest .'
            }
        }

        stage('Login to Docker Hub') {
            agent {
                docker {
                    image 'docker:24.0.2'
                    args '-v /var/run/docker.sock:/var/run/docker.sock --group-add 999'
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push to Docker Hub') {
            agent {
                docker {
                    image 'docker:24.0.2'
                    args '-v /var/run/docker.sock:/var/run/docker.sock --group-add 999'
                }
            }
            steps {
                sh 'docker push $DOCKER_IMAGE:latest'
            }
        }

        stage('Deploy to Minikube') {
            agent {
                docker {
                    image 'bitnami/kubectl:latest'
                    args '-v $HOME/.kube:/root/.kube -v $HOME/.minikube:/root/.minikube'
                }
            }
            steps {
                script {
                    // Delete old pod if exists
                    sh 'kubectl delete pod portfolio-app --ignore-not-found'

                    // Run new pod
                    sh "kubectl run portfolio-app --image=$DOCKER_IMAGE:latest --port=8080 --restart=Never"

                    // Expose pod as NodePort (ignore error if already exists)
                    sh 'kubectl expose pod portfolio-app --type=NodePort --port=8080 || true'

                    // Get service URL
                    sh 'minikube service portfolio-app --url'
                }
            }
        }
    }

    post {
        always {
            agent {
                docker {
                    image 'docker:24.0.2'
                    args '-v /var/run/docker.sock:/var/run/docker.sock --group-add 999'
                }
            }
            steps {
                sh 'docker logout'
                sh 'docker system prune -f'
            }
        }
    }
}
