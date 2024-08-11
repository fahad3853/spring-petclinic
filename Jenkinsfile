pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'fahadkhan3853/spring-petclinic:latest'
        APP_PORT = '8081'
        DOCKER_PORT = '8082'
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/fahad3853/spring-petclinic.git'
            }
        }
        stage('Build JAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }
        stage('Run Docker Compose') {
            steps {
                sh """
                echo "Running Docker container on port $DOCKER_PORT"
                docker-compose down
                docker-compose up -d
                """
            }
        }
        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh """
                kubectl apply -f k8s/deployment.yml
                kubectl apply -f k8s/service.yml
                """
            }
        }
    }
}
