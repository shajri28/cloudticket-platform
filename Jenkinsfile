pipeline {
    agent any

    environment {
        APP_NAME    = "cloudticket"
        DOCKER_IMAGE = "cloudticket-app"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code from GitHub..."
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "Building application..."
                sh 'echo "Build step - Docker build will go here"'
            }
        }

        stage('Test') {
            steps {
                echo "Running tests..."
                sh 'echo "Test step - will run unit tests"'
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying to Kubernetes..."
                sh 'echo "Deploy step - kubectl apply will go here"'
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
