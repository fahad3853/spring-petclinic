pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') // Replace with your DockerHub credentials ID
        NEXUS_CREDENTIALS = credentials('nexus-credentials') // Replace with your Nexus credentials ID
        DOCKERHUB_REPO = 'fahadkhan3853/spring-petclinic' // Replace with your DockerHub repository
        NEXUS_REPO_URL = 'http://your-nexus-repo-url/repository/maven-releases/' // Replace with your Nexus repository URL
    }
    
    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/fahad3853/spring-petclinic.git' // Replace with your GitHub repository URL
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests' // Builds the project and creates the JAR file
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh 'docker build -t ${DOCKERHUB_REPO}:latest .'
                }
            }
        }
        
        stage('Manage Docker Containers') {
            steps {
                script {
                    // Stop and remove any existing containers
                    sh 'docker-compose down'
                    
                    // Start the container using Docker Compose
                    sh 'docker-compose up -d'
                    
                    // Wait for the application to start
                    sleep(time: 30, unit: 'SECONDS')
                    
                    // Test the application
                    def statusCode = sh(script: 'curl -s -o /dev/null -w "%{http_code}" http://localhost:8082/actuator/health', returnStdout: true).trim()
                    if (statusCode != '200') {
                        error "Application is not running. Status code: ${statusCode}"
                    }
                }
            }
        }
    }
